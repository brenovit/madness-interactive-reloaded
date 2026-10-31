# Madness Interactive Reloaded

Game based on "Madness Interactive"

## Downloading the game
To start playing right away: 
1. Go to [Releases](https://github.com/studio-minus/madness-interactive-reloaded/tags) and download the .zip archive of the latest version under the "Assets" dropdown.
2. Extract the archive contents.
3. Run MIR.exe.

If you run into any issues you should first make sure you:
1. Remembered to extract the .exe before trying to run it.
2. Make sure your .NET runtime is up to date: go to the Microsoft [.NET 9](https://dotnet.microsoft.com/en-us/download/dotnet/9.0) download page. Under ".NET Desktop Runtime 9" on the right hand side and download the correct version for your OS's architecture. You can search online to figure out if your system is x64 or x86. (If your computer was made the last 10 years it's probably safe to assume x64.)

## Building the game
<!-- Keep this header at this line since the gettingstarted.md file expects it to be there. If you move it, move it there too. -->
- Assert you have these requirements
    - Windows 10 or 11 or Linux (for macOS, see [Building on macOS](#building-on-macos))
    - git
    - [.NET 9 SDK](https://dotnet.microsoft.com/en-us/download/dotnet/9.0)
    - NuGet
- Clone this repository
- Open a terminal inside the repository directory
- Initialise the submodules
    ```shell
    git submodule init
    git submodule update --remote
    ```
 - **If you DON'T have Visual Studio**
    - Navigate to the `src\MadnessInteractiveReloaded` directory and build:
        ```shell
        cd src\MadnessInteractiveReloaded 
        dotnet build
        ```
    - Debug the game by typing `dotnet run` into the terminal        

- **If you DO have Visual Studio**
    - Navigate to `src\MadnessInteractiveReloaded` directory and open the `MIR.sln` solution using VS2022
    - Press F5 (or press the ▶ button)

## Building on macOS
macOS isn't officially supported, but the game builds and runs on Apple Silicon with a few extra steps.

- Install the requirements with [Homebrew](https://brew.sh):
    ```shell
    brew install --cask dotnet-sdk
    brew install ffmpeg@5
    ```
    - `ffmpeg@5` is needed for cutscene videos. The game uses FFmpeg 5.1 and only ships the Windows libraries; newer FFmpeg versions (such as the default `ffmpeg` formula) are not compatible.
    - A newer .NET SDK/runtime than 9 is fine: the game is built with `RollForward=Major`, so it runs on whichever newer runtime is installed.
- Clone the repository and initialise the submodules as described above.
- Build from the `src\MadnessInteractiveReloaded` directory (or build `src/MIR.sln`), same as on Windows and Linux:
    ```shell
    cd src/MadnessInteractiveReloaded
    dotnet build
    ```
- Run the game, pointing it at the FFmpeg 5 libraries:
    ```shell
    cd bin/Debug/net9.0
    DYLD_LIBRARY_PATH=/opt/homebrew/opt/ffmpeg@5/lib dotnet MIR.dll
    ```
- You may see `Failed to set process priority` and `OpenAL error ... Invalid Name` messages in the console. These are harmless.
