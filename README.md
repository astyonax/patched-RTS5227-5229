# Realtek SD/MMC card reader RTS5227/5229
The default driver in the ubuntu kernel for the Realtek card reader RTS5227 or RTS5229
does not work for all sd card.

Common symptoms are:

```
$lspci
...
Unassigned class [ff00]: Realtek Semiconductor Co., Ltd. RTS5227 PCI Express Card Reader (rev 01)
...

$dmesg
...
[  251.004521] mmc0: cannot verify signal voltage switch
[  251.307113] mmc0: error -110 whilst initialising SD card
[  253.683004] mmc0: card never left busy state
[  253.683015] mmc0: error -110 whilst initialising SD card
[  256.062977] mmc0: card never left busy state
[  256.062988] mmc0: error -110 whilst initialising SD card
...
```
Often, some SD cards do not work with the default driver (in my case ``rtsx_pci``).
Not all cards trigger this error, but one of mine does (HAMA 16GB, class VI).

## Patched driver

Official drivers can be downloaded from the Realtek website, 
but require some changes to compile in new kernels (here I have linux 4.4.0).

As I do not think I can redistribure realtek code,
here I added the patch to compile the driver in Ubuntu 15.10, for kernel:

```
$uname -a
Linux *** 4.4.0-040400-generic #201601101930 SMP Mon Jan 11 00:32:41 UTC 2016 x86_64 x86_64 x86_64 GNU/Linux
```

**NOTA BENE**:
1.  I know nothing of how drivers work, I simply tried to correct the few compilation errors.
2. Although everything seems to work  fine in my machine, I do not guarantee that the changes I've done will not blow up your machine.

## Usage

1. Download the driver source code from the Realtek website  (Google or see link [4])
2. Unpack and apply the patch: ``$ patch -i patch_linux_4.4.0.diff``
3. Compile and install: ``$ make && sudo make install && sudo depmod -a``
4. Try it. See link [2]
5. Blacklist the default driver. In my case: 
`` # echo 'rtsx_pci' >> /etc/modprobe.d/blacklist.conf``

## Relevant websites
Some changes to the code are peculiar of ``Linux 4.4``, but many others were already reported:

1. http://askubuntu.com/questions/473848/ubuntu-14-04-realtek-semiconductor-co-ltd-rts5227-pci-express-card-reader-isn
2. https://abhinavgupta2812.wordpress.com/2014/01/28/getting-a-realtek-sd-card-reader-to-work-on-linux-tried-and-tested-on-debian/
3. https://bbs.archlinux.org/viewtopic.php?id=124139

Link to the Realtek driver page for RTS5229 (I have RTS5227 and it seems to work fine):
4. http://www.realtek.com/Downloads/downloadsView.aspx?Langid=1&PNid=15&PFid=25&Level=4&Conn=3&DownTypeID=3&GetDown=false#2
