# Buffalo 220 NAS

This document briefly describes how to install NFS on your buffalo device,
along with how to get remote root access, via SSH.

There are two systems involved here:

* My desktop system - which will mount the exports.
  * `10.0.0.10`
* The NAS device itself.
  * `10.0.0.108`


# Get Root

See `./root.sh` which uses `./nas`.

Once you have root you can login to your NAS via SSH and run commands
interactively.  This is a good point to stop if you're happy with Linux:

    deagol ~ $ ssh root@10.0.108
    root@10.0.108's password:

    [root@LS220DE37E ~]# uptime
     15:24:32 up 1 day,  2:12,  1 user,  load average: 0.20, 0.18, 0.70

    [root@LS220DE37E ~]# free -m
                 total       used       free     shared    buffers     cached
    Mem:           242        158         83          0         38         69
    -/+ buffers/cache:         51        190
    Swap:          975          0        975

    [root@LS220DE37E ~]# uname -r
    3.3.4

    [root@LS220DE37E ~]# cat /proc/mdstat
    Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
    md10 : active raid1 sda6[0] sdb6[1]
      2914744128 blocks super 1.2 [2/2] [UU]
      bitmap: 0/22 pages [0KB], 65536KB chunk
    md0 : active raid1 sda1[0] sdb1[1]
      999872 blocks [2/2] [UU]
    md1 : active raid1 sda2[0] sdb2[1]
      4995008 blocks super 1.2 [2/2] [UU]
    md2 : active raid1 sda5[0] sdb5[1]
      999424 blocks super 1.2 [2/2] [UU]


## Install ipkg

This is simple:

    cd /tmp
    wget http://ipkg.nslu2-linux.org/feeds/optware/cs05q3armel/cross/stable/lspro-bootstrap_1.2-7_arm.xsh
    sh ./lspro-bootstrap_1.2-7_arm.xsh

The `.xsh` script will boostrap the system, by unpackaging a binary-archive embedded within itself, and then executing it.

To view the contents of the archive you can run this:

    # dd if=lspro-bootstrap_1.2-7_arm.xsh bs=201 skip=1 2>/dev/null| tar zt
    bootstrap/
    bootstrap/bootstrap.sh
    bootstrap/ipkg-opt.ipk
    bootstrap/ipkg.sh
    bootstrap/optware-bootstrap.ipk
    bootstrap/wget.ipk

**NOTE**: Use `.. | tar xf` if you wish to unpack locally and read what will be executed.

Ultimately when `./bootstrap/bootstrap.sh` is executed it will install the two bundled `.ipkg` files (giving `ipkg` itself, and `wget` which is used to download packages), and configure `ipkg`.


## Install NFS

Once you have `ipkg`, the package-manager, installed you can install things via:

    # ipkg update
    # ipkg install $name

To get the (user-space) NFS-server you'll run:

    # ipkg update
    # ipkg install nfs-server

To configure your exports you need to edit the configuration file
`/opt/etc/exports`.  My example is this:

    /mnt/array1/backups 10.0.0.10(rw,sync)
    /mnt/array1/films   10.0.0.10(rw,sync)
    /mnt/array1/tv      10.0.0.10(rw,sync)

Once that file has been updated you'll need to restart NFS:

    /opt/etc/init.d/*nsfs* stop
    /opt/etc/init.d/*nsfs* start


## Testing NFS

From a local system in your LAN, with IP `10.0.0.10`, you should now
be able to list those exports:

    root@deagol:~# showmount -e 10.0.0.108
    Export list for 10.0.0.108:
    /mnt/array1/misc    10.0.0.10
    /mnt/array1/tv      10.0.0.10
    /mnt/array1/films   10.0.0.10
    /mnt/array1/backups 10.0.0.10


## Mounting NFS Shares

This is what I did to mount the shares on my desktop:

    mkdir /srv/films
    mount  -t nfs -o vers=2 10.0.0.108:/mnt/array1/films /srv/films

    mkdir /srv/tv
    mount  -t nfs -o vers=2 10.0.0.108:/mnt/array1/films /srv/tv

    mkdir /srv/backups
    mount  -t nfs -o vers=2 10.0.0.108:/mnt/array1/films /srv/backups


All done.



