sudo apt install qemu qemu-system-arm
qemu-system-arm -machine ?
qemu-system-arm -M versatilepb -cpu '?' 
curl -OL https://github.com/dhruvvyas90/qemu-rpi-kernel/raw/master/kernel-qemu-4.4.34-jessie 
export RPI_KERNEL=./kernel-qemu-4.4.34-jessie
curl \
-o 2019-09-26-raspbian-buster-lite.zip \
-L http://downloads.raspberrypi.org/raspbian_lite/images/raspbian_lite-2019-09-30/2019-09-26-raspbian-buster-lite.zip
unzip 2019-09-26-raspbian-buster-lite.zip
export RPI_FS=./2019-09-26-raspbian-buster-lite.img
export QEMU=$(which qemu-system-arm)
$QEMU \
  -kernel $RPI_KERNEL \
  -cpu arm1176 \
  -m 256 \
  -M versatilepb \
  -no-reboot \
  -serial stdio \
  -append "root=/dev/sda2 panic=1 rootfstype=ext4 rw init=/bin/bash" \
  -drive "file=$RPI_FS,index=0,media=disk,format=raw"
sudo sed -i -e 's/^/#/' /etc/ld.so.conf
sudo sed -i -e 's/^/#/' /etc/fstab
$QEMU \
  -kernel $RPI_KERNEL \
  -cpu arm1176 \
  -m 256 \
  -M versatilepb \
  -no-reboot \
  -serial stdio \
  -append "root=/dev/sda2 panic=1 rootfstype=ext4 rw" \
  -drive "file=$RPI_FS,index=0,media=disk,format=raw" \
  -net user,hostfwd=tcp::5022-:22 \
  -net nic
zip toflash-raspbian.zip 2019-09-26-raspbian-buster-lite.img
rm 2019-09-26-raspbian-buster-lite.* kernel-qemu-4.4.34-jessie
