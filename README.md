# Gt4Binary
Custom views to ease working with binary executable files in Glamorous Toolkit.

For the time being this package is focusing functionality on object and ELF files in the context of the Linux operating system. This note will be removed if any functionality becomes available for macOS or Windows.
## Installation```[ EpMonitor current	disableDuring: [ Metacello new			repository: 'github://botwhytho/Gt4Binary:main/src';			baseline: 'Gt4Binary';			load ] ] forkAt: 29 named: #Gt4Binary```## Load Lepiter				After installing with Metacello, you will be able to execute```#BaselineOfGt4Binary asClass loadLepiter```