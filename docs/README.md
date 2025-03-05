# Shotguard
Shotguard is an easy to use, setup and configuration free monitoring tool for Multi Theft Auto, designed to filter out shots with unrealistically high fire rates and punish cheaters.

Shotguard works by monitors players' weapon data and statistics in the background, calculates the fire rate, and uses that to decide whether a player's shot is fair or not.

> [!IMPORTANT]
> The project does not currently have a stable release, so bugs and false positives may occur. We are not responsible for any inconvenience caused.

> [!NOTE]
> The bullet sync currently works with a small delay in Multi Theft Auto, so it was necessary to introduce a temporary tolerance (250ms). This may be removed or decreased at any time as the project progresses!

## Installation
1. Download and extract the latest version of Shotguard.
2. Place the folder in the server's `mods\deathmatch\resources` directory.
3. Go to the console and type the following commands:
    1. `refresh`
    2. `aclrequest allow shotguard all`
    3. `start shotguard`
4. All done!

## FAQ
- **Q: What game mode is Shotguard designed for?**
**A:** Shotguard can be used with pretty much any game mode, as it calculates the fire rate through Multi Theft Auto's API, using Grand Theft Auto's logic.

- **Q When will the stable release of Shotguard be released?**
- **A:** Since some modifications are needed in bullet sync, which can only be done in the mtasa-blue repositry, the stable release date is not up to me.

- **Q: What configuration or setup process do I need to use Shotguard?**
- **A:** None. Shotguard calculates all values ​​automatically, so there is no need for manual configuration.

- **Q: What should I do if a player is falsely banned?**
- **A:** The resource is not connected to any central server, so you can do investigation yourself. If you find a bug, feel free to report it in our GitHub repository.

## Bans
Each ban is assigned a case number, which is a hash of the player's data. This helps players with ban appeals, as they don't have to share any personal information publicly, but the staff can easily find them.

## Contributions
We welcome all contributions! While we currently don't have any explicit coding guidelines or code of conduct, but we kindly ask that you to follow the project's naming conventions and code style.

## Credits
Thanks to all our contributors and testers for their support.  
Special thanks to [Dutchman101](https://github.com/Dutchman101) for helping with preliminary work and brainstorming.
