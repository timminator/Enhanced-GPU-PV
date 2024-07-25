<p align="center">
  <h1 align="center">Enhanced-GPU-PV</h1>
  <p align="center">
    A project dedicated to making
    <br />
    GPU Paravirtualization on Windows Hyper-V easier! 
  </p>
</p>

<br>

## ℹ About

This project is based on the "Easy-GPU-PV" project and tries to improve on it.

>GPU-PV allows you to partition your systems dedicated or integrated GPU and assign it to several Hyper-V VMs. It's the same technology that is used in WSL2, and Windows Sandbox.  
Easy-GPU-PV aims to make this easier by automating the steps required to get a GPU-PV VM up and running.  
Easy-GPU-PV does the following...  
>1) Creates a VM of your choosing.
>2) Automatically Installs Windows to the VM.
>3) Partitions your GPU of choice and copies the required driver files to the VM.  
>4) Installs [Parsec](https://parsec.app) to the VM. Parsec is an ultra low latency remote desktop app, use this to connect to the VM.  You can use Parsec for free non commercially. To use Parsec commercially, sign up to a [Parsec For Teams](https://parsec.app/teams) account.

The original project only allowed the user to set up Parsec and no alternative like Sunshine/Moonlight.   Furthermore it only added a virtual display to the VM when the user connected to it by relying on the fallback display of the Parsec App and its Privacy Mode.   
This could lead to some [issues](https://github.com/jamesstringerparsec/Easy-GPU-PV/issues/190) and also meant that the screen was disconnected when no user was connected, causing problems for some people including me ;-). When connecting to the VM you were also logged out.  
This updated version lets the user choose if he wants to install Sunshine or Parsec. It also adds a permanently connected virtual display to the VM, resolving the aforementioned issues. The user can also decide between to different Virtual Display solutions.  
One [solution](https://github.com/timminator/ParsecVDA-Always-Connected) is based on the Parsec Virtual Display Driver. The other [solution](https://github.com/timminator/Virtual-Display-Driver) utilizes the Virtual Display Driver by [itsmikethetech](https://github.com/itsmikethetech) that i modified so that it can be installed remotely in this project.  
Both solutions allow high resolutions and high refresh rates.  


A summary of the most important changes compared to the original project:
* Allows the user to install Sunshine or Parsec
* Adds a permanently connected virtual display to the VM without relying on the Parsec App
* The user can choose between to different virtual display solutions

Minor changes:
* The installation also disables the OneDrive autostart. It caused problems due to setting up a local account and not a Microsoft account.
* Adds language and timezone to the configurable parameters of the installation.
* The installation sets the time for turning off the display to "Never". 


## Prerequisites:

* Windows 10 20H1+ Pro, Enterprise or Education OR Windows 11 Pro, Enterprise or Education.  Windows 11 on host and VM is preferred due to better compatibility.  
* Matched Windows versions between the host and VM. Mismatches may cause compatibility issues, blue-screens, or other issues. (Win10 21H2 + Win10 21H2, or Win11 21H2 + Win11 21H2, for example).  
* Desktop Computer with dedicated NVIDIA/AMD GPU or Integrated Intel GPU - Laptops with NVIDIA GPUs are not supported at this time, but Intel integrated GPUs work on laptops.  GPU must support hardware video encoding (NVIDIA NVENC, Intel Quicksync or AMD AMF).  
* Latest GPU driver from Intel.com, NVIDIA.com or AMD.com, don't rely on device manager or Windows update.  
* Latest Windows 10/11 ISO can be [downloaded from here](https://www.microsoft.com/en-gb/software-download/windows10ISO) and  [from here.](https://www.microsoft.com/en-us/software-download/windows11) - Do not use Media Creation Tool, if no direct ISO link is available, follow [this guide.](https://www.nextofwindows.com/downloading-windows-10-iso-images-using-rufus)
* Virtualization need to be enabled in the motherboard and [Hyper-V needs to be fully enabled](https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/quick-start/enable-hyper-v) on the Windows 10/ 11 OS (requires reboot).  
* Allow Powershell scripts to run on your system - typically by running "Set-ExecutionPolicy unrestricted" in Powershell running as Administrator.
* On first boot of the VM an internet connection is required for installing Parsec, the Virtual Display and the audio driver.


## Steps to get it running:

1. Make sure your system meets the prerequisites.
2. Download the latest release and extract it.
3. Search your system for Powershell ISE and run it as Administrator.
4. In the extracted folder you downloaded, open PreChecks.ps1 in Powershell ISE and run it by using the green play button and copy the GPU listed (or the warnings that you need to fix).
5. Open CopyFilesToVM.ps1 in Powershell ISE and edit the params section at the top of the file. Further notes regarding these parameters you can find down below.
6. Run CopyFilesToVM.ps1 with your changes to the params section - this may take 5-10 minutes.
7. Open and sign into Parsec or Sunshine on the VM. If you're using Sunshine also pair your VM with a client.
8. After that double click the shortcut "Switch Display to ParsecVDA/Virtual Display" depending on your chosen solution. Your mouse inside the VM will disappear. Close the window on the host. Use Parsec or Moonlight to connect to the VM.

You should be good to go!

## Notes:

- If you're using the Sunshine/Moonlight solution I would advice you to do a restart of the VM after your first connection via Moonlight.  
For some reason on the first switch to the Virtual Display the refresh rate is not hitting the set limit. For example on a 60hz refresh rate its limited to 56 fps instead and can be verified by a website like testufo.com. This causes dropped frames. After a restart the problem never occurs again.
- Connections to the VM can take up to 60 seconds. This can cause problems when using the default moonlight client, as it has a timeout window of 10 seconds. If no frame is received in this timeframe the connection attempt times out. This can lead to needing several attempts to successfully connect to the VM via Moonlight.  
To solve this problem, i also created a new Moonlight build that increases this timeout to 60 seconds instead. You can check it out [here](https://github.com/timminator/Moonlight-Tailored-for-GPU-PV).

## Upgrading GPU Drivers after updating the host GPU Drivers:

It's important to update the VM GPU drivers after you have updated the Host GPUs drivers. You can do this by...  
1. Shut down your VM and reboot the host after updating GPU drivers.  
2. Open Powershell as administrator and change the directory (CD) to the path where CopyFilesToVM.ps1 and Update-VMGpuPartitionDriver.ps1 are located. 
3. Run ```Update-VMGpuPartitionDriver.ps1 -VMName "Name of your VM" -GPUName "Name of your GPU"```    (Windows 10 GPU name must be "AUTO")


## Values:

Some more infos about the Parameters needed to be set in CopyFilesToVM.ps1:

  * ```VMName = "GPUP"``` - Name of VM in Hyper-V and the computername / hostname  
  * ```SourcePath = "C:\Users\james\Downloads\Win11_English_x64.iso"``` - path to Windows 10/ 11 ISO on your host   
  * ```Edition    = 6``` - Leave as 6, this means Windows 10/11 Pro  
  * ```VhdFormat  = "VHDX"``` - Leave this value alone  
  * ```DiskLayout = "UEFI"``` - Leave this value alone  
  * ```SizeBytes  = 40GB``` - Disk size, in this case 40GB, the minimum is 20GB  
  * ```MemoryAmount = 8GB``` - Memory size, in this case 8GB  
  * ```CPUCores = 4``` - CPU cores you want to assign to the VM, in this case 4   
  * ```NetworkSwitch = "Default Switch"``` - Create a new external network switch beforehand in Hyper-V Manager. A tutorial you can find [here](https://www.youtube.com/watch?v=XLLcc29EZ_8&t=707s).   
  * ```VHDPath = "C:\ProgramData\Microsoft\Windows\Virtual Hard Disks\"``` - Path to the folder you want the VM disk to be stored in, it must already exist, currently set to default path in Windows 11  
  * ```UnattendPath = "$PSScriptRoot"+"\autounattend.xml"``` -Leave this value alone  
  * ```GPUName = "AUTO"``` - AUTO selects the first available GPU. On Windows 11 you may also use the exact name of the GPU you want to share with the VM in multi GPU situations (GPU selection is not available in Windows 10 and must be set to AUTO)    
  * ```GPUResourceAllocationPercentage = 50``` - Percentage of the GPU you want to share with the VM
  * ```Parsec = $true``` - Decide if you want to install Parsec or not
  * ```ParsecVDA = $true``` - Decide if you want to install the Parsec Virtual Display sol. or not
  * ```Sunshine = $true``` - Decide if you want to install Sunshine or not
  * ```VirtualDisplayDriver = $true``` - Decide if you want to install the Virtual Display Driver sol. or not
  * ```Team_ID = ""``` - The Parsec for Teams ID if you are a Parsec for Teams Subscriber  
  * ```Key = ""``` - The Parsec for Teams Secret Key if you are a Parsec for Teams Subscriber  
  * ```Username = "GPUVM"``` - The VM Windows Username, do not include special characters, and must be different from the "VMName" value you set  
  * ```Password = "CoolestPassword!"``` - The VM Windows Password, cannot be blank    
  * ```Autologon = "true"``` - If you want the VM to automatically login to the Windows Desktop  
  * ```Language = ""``` - Only affects keyboard layout and other minor settings, language is predetermined by the specified ISO. If you want to use the default settings by your ISO leave this parameter empty like this: ""  
  * ```Timezone = ""``` - If you want to use the default settings by your ISO leave this parameter empty like this: ""


## Further Notes:  

- After you have signed into Parsec or Sunshine on the VM, always use Parsec or Moonlight to connect to the VM.
- You can also set all four parameters regarding Parsec, Sunshine and virtual display solutions to false and just create a VM with GPU-PV support if this is what you need.
- If you get the message "ERROR  : Cannot bind argument to parameter 'Path' because it is null." : This probably means you used Media Creation Tool to download the ISO.  You unfortunately cannot use that, if you don't see a direct ISO download link at the Microsoft page, follow [this guide.](https://www.nextofwindows.com/downloading-windows-10-iso-images-using-rufus)  
- Your GPU on the host will have a Microsoft driver in device manager, rather than an nvidia/intel/amd driver. As long as it doesn't have a yellow triangle on top of the device in device manager, it's working correctly.  
- A powered on display / HDMI dummy dongle must be plugged into the GPU to allow Parsec to capture the screen. You only need one of these per host machine regardless of number of VM's. You can also use the same [Virtual Display Driver](https://github.com/timminator/ParsecVDA-Always-Connected) used in this enhanced version. I would appreciate it if you check it out. This allows your host to run headless aswell.
- If your computer is super fast it may get to the login screen before the audio driver (VB Cable) and Parsec display driver are installed, but fear not! They should soon install. The installation is finished when the shortcut "Switch Display to ParsecVDA" is displayed on your desktop.  
- The screen may go black for times up to 60 seconds in situations when UAC prompts appear, applications go in and out of fullscreen and when you switch between video codecs in Parsec - not really sure why this happens, it's unique to GPU-P machines and seems to recover faster at 1280x720.
- Vulkan renderer is unavailable and GL games may or may not work.  [This](https://www.microsoft.com/en-us/p/opencl-and-opengl-compatibility-pack/9nqpsl29bfff?SilentAuth=1&wa=wsignin1.0#activetab=pivot:overviewtab) may help with some OpenGL apps.  
- If you do not have administrator permissions on the machine it means you set the username and vmname to the same thing, these needs to be different.  
- AMD Polaris GPUS like the RX 580 do not support hardware video encoding via GPU Paravirtualization at this time.  
- To download Windows ISOs with Rufus, it must have "Check for updates" enabled.
- The minimum OS version changed to Windows 10 21H2 Pro, due to the usage of newest Parsec virtual display driver.


## Acknowledgements of the main project:  

- [Hyper-ConvertImage](https://github.com/tabs-not-spaces/Hyper-ConvertImage) for creating an updated version of [Convert-WindowsImage](https://github.com/MicrosoftDocs/Virtualization-Documentation/tree/master/hyperv-tools/Convert-WindowsImage) that is compatible with Windows 10 and 11.
- [gawainXX](https://github.com/gawainXX) for help testing and pointing out bugs and feature improvements. 
