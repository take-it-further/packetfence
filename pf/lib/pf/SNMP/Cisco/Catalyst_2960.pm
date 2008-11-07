#
# Copyright 2006-2008 Inverse groupe conseil
#
# See the enclosed file COPYING for license information (GPL).
# If you did not receive this file, see
# http://www.fsf.org/licensing/licenses/gpl.html
#

package pf::SNMP::Cisco::Catalyst_2960;

=head1 NAME

pf::SNMP::Cisco::Catalyst_2960 - Object oriented module to access SNMP enabled Cisco Catalyst 2960 switches


=head1 SYNOPSIS

The pf::SNMP::Cisco::Catalyst_2960 module implements an object oriented interface
to access SNMP enabled Cisco::Catalyst_2960 switches.

This modules extends pf::SNMP::Cisco::Catalyst_2950

=cut

use strict;
use warnings;
use diagnostics;
use Log::Log4perl;
use Net::SNMP;

use base ('pf::SNMP::Cisco::Catalyst_2950');

sub getMinOSVersion {
    my ($this) = @_;
    my $logger = Log::Log4perl::get_logger(ref($this));
    return '12.2(25)SEE2';
}

sub getAllSecureMacAddresses {
    my ($this) = @_;
    my $logger = Log::Log4perl::get_logger(ref($this));
    my $oid_cpsIfVlanSecureMacAddrRowStatus = '1.3.6.1.4.1.9.9.315.1.2.3.1.5';    

    my $secureMacAddrHashRef = {};
    if (! $this->connectRead()) {
        return $secureMacAddrHashRef;
    }
    $logger->trace("SNMP get_table for cpsIfVlanSecureMacAddrRowStatus: $oid_cpsIfVlanSecureMacAddrRowStatus");
    my $result = $this->{_sessionRead}->get_table(
        -baseoid => "$oid_cpsIfVlanSecureMacAddrRowStatus"
    );
    foreach my $oid_including_mac (keys %{$result}) {
        if ($oid_including_mac =~ /^$oid_cpsIfVlanSecureMacAddrRowStatus\.([0-9]+)\.([0-9]+)\.([0-9]+)\.([0-9]+)\.([0-9]+)\.([0-9]+)\.([0-9]+)\.([0-9]+)$/) {
            my $oldMac = sprintf("%02x:%02x:%02x:%02x:%02x:%02x", $2, $3, $4, $5, $6, $7);
            my $oldVlan = $8;
            my $ifIndex = $1;
            push @{$secureMacAddrHashRef->{$oldMac}->{$ifIndex}}, $oldVlan;
        }
    }

    return $secureMacAddrHashRef;
}

sub isDynamicPortSecurityEnabled {
    my ($this, $ifIndex) = @_;
    my $logger = Log::Log4perl::get_logger(ref($this));
    my $oid_cpsIfVlanSecureMacAddrType = '1.3.6.1.4.1.9.9.315.1.2.3.1.3';

    if (! $this->connectRead()) {
        return 0;
    }
    if (! $this->isPortSecurityEnabled($ifIndex)) {
        $logger->debug("port security is not enabled");
        return 0;
    }

    $logger->trace("SNMP get_table for cpsIfVlanSecureMacAddrType: $oid_cpsIfVlanSecureMacAddrType");
    my $result = $this->{_sessionRead}->get_table(
        -baseoid => "$oid_cpsIfVlanSecureMacAddrType.$ifIndex"
    );
    foreach my $oid_including_mac (keys %{$result}) {
        if (($result->{$oid_including_mac} == 1) || ($result->{$oid_including_mac} == 3)) {
            return 0;
        }
    }

    return 1;
}

sub isStaticPortSecurityEnabled {
    my ($this, $ifIndex) = @_;
    my $logger = Log::Log4perl::get_logger(ref($this));
    my $oid_cpsIfVlanSecureMacAddrType = '1.3.6.1.4.1.9.9.315.1.2.3.1.3';

    if (! $this->connectRead()) {
        return 0;
    }
    if (! $this->isPortSecurityEnabled($ifIndex)) {
        $logger->info("port security is not enabled");
        return 0;
    }

    $logger->trace("SNMP get_table for cpsIfVlanSecureMacAddrType: $oid_cpsIfVlanSecureMacAddrType");
    my $result = $this->{_sessionRead}->get_table(
        -baseoid => "$oid_cpsIfVlanSecureMacAddrType.$ifIndex"
    );
    foreach my $oid_including_mac (keys %{$result}) {
        if (($result->{$oid_including_mac} == 1) || ($result->{$oid_including_mac} == 3)) {
            return 1;
        }
    }

    return 0;
}

sub getSecureMacAddresses {
    my ($this, $ifIndex) = @_;
    my $logger = Log::Log4perl::get_logger(ref($this));
    my $oid_cpsIfVlanSecureMacAddrRowStatus = '1.3.6.1.4.1.9.9.315.1.2.3.1.5';  

    my $secureMacAddrHashRef = {};
    if (! $this->connectRead()) {
        return $secureMacAddrHashRef;
    }
    $logger->trace("SNMP get_table for cpsIfVlanSecureMacAddrRowStatus: $oid_cpsIfVlanSecureMacAddrRowStatus");
    my $result = $this->{_sessionRead}->get_table(
        -baseoid => "$oid_cpsIfVlanSecureMacAddrRowStatus.$ifIndex"
    );
    foreach my $oid_including_mac (keys %{$result}) {
        if ($oid_including_mac =~ /^$oid_cpsIfVlanSecureMacAddrRowStatus\.$ifIndex\.([0-9]+)\.([0-9]+)\.([0-9]+)\.([0-9]+)\.([0-9]+)\.([0-9]+)\.([0-9]+)$/) {
            my $oldMac = sprintf("%02x:%02x:%02x:%02x:%02x:%02x", $1, $2, $3, $4, $5, $6);
            my $oldVlan = $7;
            push @{$secureMacAddrHashRef->{$oldMac}}, int($oldVlan);
        }
    }

    return $secureMacAddrHashRef;
}

sub authorizeMAC {
    my ($this, $ifIndex, $deauthMac, $authMac, $deauthVlan, $authVlan) = @_;
    my $logger = Log::Log4perl::get_logger(ref($this));
    my $oid_cpsIfVlanSecureMacAddrRowStatus = '1.3.6.1.4.1.9.9.315.1.2.3.1.5';

    if (! $this->isProductionMode()) {
        $logger->info("not in production mode ... we won't add an entry to the SecureMacAddrTable");
        return 1;
    }

    if (! $this->connectWrite()) {
        return 0;
    }

    my $voiceVlan = $this->getVoiceVlan($ifIndex);
    if (($deauthVlan == $voiceVlan) || ($authVlan == $voiceVlan)) {
        $logger->error("ERROR: authorizeMAC called with voice VLAN .... this should not have happened ... we won't add an entry to the SecureMacAddrTable");
        return 1;
    }

    my @oid_value;
    if ($deauthMac) {
        my @macArray = split(/:/, $deauthMac);
        my $completeOid = $oid_cpsIfVlanSecureMacAddrRowStatus . "." . $ifIndex;
        foreach my $macPiece (@macArray) {
            $completeOid .= "." . hex($macPiece);
        }
        $completeOid .= "." . $deauthVlan;
        push @oid_value, ($completeOid, Net::SNMP::INTEGER, 6);
    }
    if ($authMac) {
        my @macArray = split(/:/, $authMac);
        my $completeOid = $oid_cpsIfVlanSecureMacAddrRowStatus . "." . $ifIndex;
        foreach my $macPiece (@macArray) {
            $completeOid .= "." . hex($macPiece);
        }
        $completeOid .= "." . $deauthVlan;
        push @oid_value, ($completeOid, Net::SNMP::INTEGER, 4);
    }

    if (scalar(@oid_value) > 0) {
        $logger->trace("SNMP set_request for cpsIfVlanSecureMacAddrRowStatus");
        my $result = $this->{_sessionWrite}->set_request(
            -varbindlist => \@oid_value
        );
    }
}                                        

1;

# vim: set shiftwidth=4:
# vim: set expandtab:
# vim: set backspace=indent,eol,start:
