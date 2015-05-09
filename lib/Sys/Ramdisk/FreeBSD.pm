###########################################
package Sys::Ramdisk::FreeBSD;
###########################################
use strict;
use warnings;
use Log::Log4perl qw(:easy);
use Sysadm::Install qw(bin_find tap);

use base qw(Sys::Ramdisk);

###########################################
sub mount {
###########################################
    my($self) = @_;

      # mkdir -p /mnt/myramdisk
      # /sbin/mdmfs -s 32m md /mnt/myramdisk

     for (qw(dir size)) {
         if(! defined $self->{ $_ }) {
             LOGWARN "Mandatory parameter $_ not set";
             return undef;
         }
     }

     $self->{mdmfs}  = '/sbin/mdmfs';
     $self->{umount} = '/sbin/umount';

     my @cmd = ($self->{mdmfs},
                "-s", $self->{size},
                "md", $self->{dir});

     INFO "Mounting ramdisk: @cmd";
     my($stdout, $stderr, $rc) = tap @cmd;

    if($rc) {
        LOGWARN "Mount command '@cmd' failed: $stderr";
        return;
    }

    $self->{mounted} = 1;

    return 1;
}

###########################################
sub unmount {
###########################################
    my($self) = @_;

    return if !exists $self->{mounted};

    my @cmd = ($self->{umount}, $self->{dir});

    INFO "Unmounting ramdisk: @cmd";

     my($stdout, $stderr, $rc) = tap @cmd;

    if($rc) {
        LOGWARN "Mount command '@cmd' failed: $stderr";
        return;
    }

    $self->{mounted} = 0;

    return 1;
}

1;

__END__

=head1 NAME

Sys::Ramdisk::FreeBSD - Mount and unmount RAM disks on FreeBSD

=head1 SYNOPSIS

    # Use base class Sys::Ramdisk instead

=head1 DESCRIPTION

Sys::Ramdisk::FreeBSD mounts and unmounts RAM disks on FreeBSD.

=head1 LEGALESE

Copyright 2015 by Robert Drake, all rights reserved.
This program is free software, you can redistribute it and/or
modify it under the same terms as Perl itself.

=head1 AUTHOR

2015, Robert Drake <rdrake@cpan.org>
