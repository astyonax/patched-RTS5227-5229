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
Not all cards trigger this error, but one of mine does (HAMA SDHC 16GB, class 10).

Changes to original repository by astyonax:
- Added DKMS support

## Patched driver

I tested the compilation on:

* Linux 4.15.0 
* Linux 4.14.0 
* Linux 4.12.0 
* Linux 4.10.2
* Linux 4.9.0
* Linux 4.7.0
* Linux 4.6.3
* Linux 4.4.0
* Linux 4.3.3



**NOTA BENE**:

1. I know nothing of how drivers work, I simply tried to correct the few compilation errors.
2. Although everything seems to work  fine in my machine, I do not guarantee that the changes I've done will not blow up your machine.

## Usage

### Manual (updated by Stane1983)

1. Clone this repo & cd in the repo folder
2. Add rtsx_pci to blacklisted modules as follows:
```
echo 'blacklist rtsx_pci' >> /etc/modprobe.d/blacklist.conf
```
3. compile and install driver using DKMS:
```
sudo dkms add ./rts5229
sudo dkms install rts5227/1.07
```
4. Unload the module before suspend
```
echo SUSPEND_MODULES="rts5227" | sudo tee -a /etc/pm/config.d/modules
```
5. Reboot your machine

## Relevant websites
Some changes to the code are peculiar of ``Linux 4.4``, but many others were already reported:

1. http://askubuntu.com/questions/473848/ubuntu-14-04-realtek-semiconductor-co-ltd-rts5227-pci-express-card-reader-isn
2. https://abhinavgupta2812.wordpress.com/2014/01/28/getting-a-realtek-sd-card-reader-to-work-on-linux-tried-and-tested-on-debian/
3. https://bbs.archlinux.org/viewtopic.php?id=124139

Link to the Realtek driver page for RTS5229 (I have RTS5227 but it seems to be working fine):

4. http://www.realtek.com/Downloads/downloadsView.aspx?Langid=1&PNid=15&PFid=25&Level=4&Conn=3&DownTypeID=3&GetDown=false#2
