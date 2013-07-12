package pf::cmd::pf::ifoctetshistorymac;
=head1 NAME

pf::cmd::pf::ifoctetshistorymac add documentation

=head1 SYNOPSIS

pfcmd ifoctetshistorymac mac

get the bytes throughput generated by a specified MAC with optional date

examples:

  pfcmd ifoctetshistorymac 00:11:22:33:44:55
  pfcmd ifoctetshistorymac 00:11:22:33:44:55 start_time=2007-10-12 10:00:00,end_time=2007-10-13 10:00:00

=head1 DESCRIPTION

pf::cmd::pf::ifoctetshistorymac

=cut

use strict;
use warnings;
use base qw(pf::cmd::display);
use pf::cmd::roles::show_help;
use pf::ifoctetslog;

sub parseArgs {
    my ($self) = @_;
    my ($key,@dates) = $self->args;
    if (defined $key) {
        my %params;
        if(@dates == 2) {
            $params{'start_time'} = str2time( $dates[0]);
            $params{'end_time'} = str2time( $dates[1]);
        }
        $self->{key} = $key;
        $self->{params} = \%params;
        $self->{function} = \&ifoctetslog_history_mac;
        return 1;
    }
    return 0;
}

=head1 AUTHOR

Inverse inc. <info@inverse.ca>

Minor parts of this file may have been contributed. See CREDITS.

=head1 COPYRIGHT

Copyright (C) 2005-2013 Inverse inc.

=head1 LICENSE

This program is free software; you can redistribute it and::or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301,
USA.

=cut

1;

