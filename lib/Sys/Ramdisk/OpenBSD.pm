###########################################
package Sys::Ramdisk::OpenBSD;
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
      # mount_mfs -s 32m swap /mnt/myramdisk

     for (qw(dir size)) {
         if(! defined $self->{ $_ }) {
             LOGWARN "Mandatory parameter $_ not set";
             return undef;
         }
     }

     $self->{mount_mfs}  = '/sbin/mount_mfs';
     $self->{umount} = '/sbin/umount';

     my @cmd = ($self->{mount_mfs},
                "-s", $self->{size},
                "swap", $self->{dir});

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

Sys::Ramdisk::OpenBSD - Mount and unmount RAM disks on OpenBSD

=head1 SYNOPSIS

    # Use base class Sys::Ramdisk instead

=head1 DESCRIPTION

Sys::Ramdisk::OpenBSD mounts and unmounts RAM disks on OpenBSD.

=head1 LEGALESE

Copyright 2015 by Robert Drake, all rights reserved.
This program is free software, you can redistribute it and/or
modify it under the same terms as Perl itself.

=head1 AUTHOR

2015, Robert Drake <rdrake@cpan.org>
