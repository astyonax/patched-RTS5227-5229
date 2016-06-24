#! /bin/bash
set -e

echo "------------------------------------------------------------------------"
echo "RTS5227-5229 patch - Guglielmo Saggiorato <astyonax@gmail.com> - 28.6.16"
echo "------------------------------------------------------------------------"
echo 
echo "Run this script from within the drivers' folder"
echo "Run as unprivileged user"
echo
echo "Expected folder structure:"
echo "../patch_linux_4.4.0.diff"
echo "../run.sh"
echo "PWD=rts5229" 
echo
echo "Type <enter> to continue"
echo "Type ctrl+c to quit"
read

if [[ -e ../patch_linux_4.4.0.diff ]]
then
	patch -i ../patch_linux_4.4.0.diff
else
  echo "I couldn't find the patch file"
  echo "Please, proceed with manually"
  exit
fi

make -j 4
sudo make install
sudo depmod -a

echo 'blacklist rtsx_pci' | sudo tee -a /etc/modprobe.d/blacklist.conf 
sudo update-initramfs -u


echo "Success"

