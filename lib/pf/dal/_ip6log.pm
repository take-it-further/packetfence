package pf::dal::_ip6log;

=head1 NAME

pf::dal::_ip6log - pf::dal implementation for the table ip6log

=cut

=head1 DESCRIPTION

pf::dal::_ip6log

pf::dal implementation for the table ip6log

=cut

use strict;
use warnings;

###
### pf::dal::_ip6log is auto generated any change to this file will be lost
### Instead change in the pf::dal::ip6log module
###
use base qw(pf::dal);

our @FIELD_NAMES;
our @INSERTABLE_FIELDS;
our @PRIMARY_KEYS;
our %DEFAULTS;
our %FIELDS_META;
our @COLUMN_NAMES;

BEGIN {
    @FIELD_NAMES = qw(
        tenant_id
        mac
        ip
        type
        start_time
        end_time
    );

    %DEFAULTS = (
        tenant_id => '1',
        mac => '',
        ip => '',
        type => undef,
        start_time => '',
        end_time => '0000-00-00 00:00:00',
    );

    @INSERTABLE_FIELDS = qw(
        tenant_id
        mac
        ip
        type
        start_time
        end_time
    );

    %FIELDS_META = (
        tenant_id => {
            type => 'INT',
            is_auto_increment => 0,
            is_primary_key => 1,
            is_nullable => 0,
        },
        mac => {
            type => 'VARCHAR',
            is_auto_increment => 0,
            is_primary_key => 0,
            is_nullable => 0,
        },
        ip => {
            type => 'VARCHAR',
            is_auto_increment => 0,
            is_primary_key => 1,
            is_nullable => 0,
        },
        type => {
            type => 'VARCHAR',
            is_auto_increment => 0,
            is_primary_key => 0,
            is_nullable => 1,
        },
        start_time => {
            type => 'DATETIME',
            is_auto_increment => 0,
            is_primary_key => 0,
            is_nullable => 0,
        },
        end_time => {
            type => 'DATETIME',
            is_auto_increment => 0,
            is_primary_key => 0,
            is_nullable => 1,
        },
    );

    @PRIMARY_KEYS = qw(
        tenant_id
        ip
    );

    @COLUMN_NAMES = qw(
        ip6log.tenant_id
        ip6log.mac
        ip6log.ip
        ip6log.type
        ip6log.start_time
        ip6log.end_time
    );

}

use Class::XSAccessor {
    accessors => \@FIELD_NAMES,
};

=head2 _defaults

The default values of ip6log

=cut

sub _defaults {
    return {%DEFAULTS};
}

=head2 field_names

Field names of ip6log

=cut

sub field_names {
    return [@FIELD_NAMES];
}

=head2 primary_keys

The primary keys of ip6log

=cut

sub primary_keys {
    return [@PRIMARY_KEYS];
}

=head2

The table name

=cut

sub table { "ip6log" }

our $FIND_SQL = do {
    my $where = join(", ", map { "$_ = ?" } @PRIMARY_KEYS);
    "SELECT * FROM `ip6log` WHERE $where;";
};

=head2 find_columns

find_columns

=cut

sub find_columns {
    return [@COLUMN_NAMES];
}

=head2 _find_one_sql

The precalculated sql to find a single row ip6log

=cut

sub _find_one_sql {
    return $FIND_SQL;
}

=head2 _updateable_fields

The updateable fields for ip6log

=cut

sub _updateable_fields {
    return [@FIELD_NAMES];
}

=head2 _insertable_fields

The insertable fields for ip6log

=cut

sub _insertable_fields {
    return [@INSERTABLE_FIELDS];
}

=head2 get_meta

Get the meta data for ip6log

=cut

sub get_meta {
    return \%FIELDS_META;
}

=head2 update_params_for_select

Automatically add the current tenant_id to the where clause of the select statement

=cut

sub update_params_for_select {
    my ($self, %args) = @_;
    unless ($args{'-no_auto_tenant_id'}) {
        my $where = {
            tenant_id => $self->get_tenant,
        };
        my $old_where = delete $args{-where};
        if (defined $old_where) {
            $where->{-and} = $old_where;
        }
        $args{-where} = $old_where;
    }
    return $self->SUPER::update_params_for_select(%args);
}

=head2 update_params_for_update

Automatically add the current tenant_id to the where clause of the update statement

=cut

sub update_params_for_update {
    my ($self, %args) = @_;
    unless ($args{'-no_auto_tenant_id'}) {
        my $where = {
            tenant_id => $self->get_tenant,
        };
        my $old_where = delete $args{-where};
        if (defined $old_where) {
            $where->{-and} = $old_where;
        }
        $args{-where} = $old_where;
    }
    return $self->SUPER::update_params_for_select(%args);
}

=head2 update_params_for_delete

Automatically add the current tenant_id to the where clause of the delete statement

=cut

sub update_params_for_delete {
    my ($self, %args) = @_;
    unless ($args{'-no_auto_tenant_id'}) {
        my $where = {
            tenant_id => $self->get_tenant,
        };
        my $old_where = delete $args{-where};
        if (defined $old_where) {
            $where->{-and} = $old_where;
        }
        $args{-where} = $old_where;
    }
    return $self->SUPER::update_params_for_select(%args);
}

=head2 update_params_for_insert

Automatically add the current tenant_id to the set clause of the insert statement

=cut

sub update_params_for_insert {
    my ($self, %args) = @_;
    unless ($args{'-no_auto_tenant_id'}) {
        my $old_set = delete $args{-set} // {};
        $old_set->{tenant_id} = $self->get_tenant;
        $args{-set} = $old_set;
    }
    return $self->SUPER::update_params_for_insert(%args);
}

=head2 defaults

=cut

sub defaults {
    my ($self) = @_;
    return {%{$self->SUPER::defaults}, tenant_id => $self->get_tenant};
}

 
=head1 AUTHOR

Inverse inc. <info@inverse.ca>

=head1 COPYRIGHT

Copyright (C) 2005-2017 Inverse inc.

=head1 LICENSE

This program is free software; you can redistribute it and/or
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
