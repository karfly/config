# config
karfly's config files for new machines.

## Quick Installation
One-line installation using wget:

```bash
# Use system hostname automatically:
wget -O- https://raw.githubusercontent.com/karfly/config/master/install.sh | bash

# OR specify a custom hostname:
wget -O- https://raw.githubusercontent.com/karfly/config/master/install.sh | bash -s my-custom-hostname
```

## Manual Installation
If you've already cloned the repository:

```bash
# Interactive mode (will prompt for hostname):
chmod +x install.sh
./install.sh

# Specify hostname directly:
./install.sh my-custom-hostname
```