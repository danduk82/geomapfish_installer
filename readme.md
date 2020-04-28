# GEOMAPFISH INSTALLER

This project contains a packaged version of the [software geomapfish v.2.5](https://github.com/camptocamp/c2cgeoportal/).

Please use the [online documentation](https://geomapfish.org/) for further infos on normal geomapfish utiliszation or management.

## Using this installer

This installer contains the base docker images needed to perform a full installation and build of the application, and the code of a basic geomapfish installation.

1. Clone this **Geomapfish Installer** project:

    ```shell
    git clone https://github.com/danduk82/geomapfish_installer.git
    ```

2. Clone the [**package_gmf**](https://github.com/danduk82/package_gmf) project inside the _geomapfish_installer_ directory:

    ```shell
    cd geomapfish_installer
    git clone https://github.com/danduk82/package_gmf
    ```

3. Install the images and build the sample project simply type:

    ```shell
    ./install.sh -i
    ```

Then visit [your local install](https://localhost:8484/) in a webrowser.
