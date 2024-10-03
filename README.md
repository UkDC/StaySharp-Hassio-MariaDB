# StaySharp



# StaySharp

## Description

**StaySharp** is an add-on for Home Assistant that provides a calculator for the Tormek T-8 sharpening machine. It allows you to calculate optimal sharpening parameters for tools, ensuring precision and efficiency in your work.

## Installation

1. **Add the add-on repository to Home Assistant**:

   - Go to **Supervisor** > **Add-on Store**.
   - Click on the three-dot menu icon in the top right corner and select **Repositories**.
   - In the input field, add the following URL and click **Add**:

     ```
     https://github.com/UkDC/StaySharp-Hassio-MariaDB
     ```

2. **Install the add-on**:

   - Find the **StaySharp** add-on in the list of available add-ons.
   - Click on the add-on and then click the **Install** button.

## Configuration

Before starting the add-on, you need to configure database connection parameters and superuser credentials.

### **Configuration Parameters**

Open the **Configuration** tab of the add-on and set the following parameters:

```yaml
db_host: "core-mariadb"
db_port: 3306
db_name: "homeassistant"
db_user: "user"
db_password: "password"
create_superuser: false
superuser_username: "admin"
superuser_email: "admin@example.com"
superuser_password: "your_password"
```

#### **Parameter Descriptions**

- **db_host**: The address of the MariaDB database (usually `core-mariadb`).
- **db_port**: The port of the MariaDB database (default is `3306`).
- **db_name**: The name of the database (often `homeassistant`).
- **db_user**: The database username.
- **db_password**: The database user's password.
- **create_superuser**: Flag to create a Django superuser (`true` or `false`).
- **superuser_username**: The superuser's username.
- **superuser_email**: The superuser's email address.
- **superuser_password**: The superuser's password.

**Note**: Ensure that the MariaDB add-on is installed and running, and that the connection parameters match your database settings.

## Usage

1. **Start the add-on**:

   - Go to the **Info** tab of the **StaySharp** add-on.
   - Click the **Start** button.

2. **Open the web interface**:

   - After starting the add-on, click the **Open Web UI** button.
   - The application will be accessible at `http://<your_Home_Assistant_address>:8000`.

3. **Log in**:

   - Use the superuser credentials specified in the configuration to log in to the application.

## Updating

To update the add-on to the latest version:

1. **Stop the add-on**:

   - Go to the **Info** tab of the add-on and click the **Stop** button.

2. **Update the add-on**:

   - If an update is available, an **Update** button will appear. Click it.

3. **Start the add-on** after the update is complete.

## Troubleshooting

- **Add-on does not start**:

  - Check the add-on logs in the **Log** tab to identify errors.
  - Ensure that the database parameters are correct and that the database is accessible.

- **Database connection error**:

  - Ensure that the MariaDB add-on is installed and running.
  - Verify the correctness of the database credentials provided.

- **Unable to log in to the application**:

  - Ensure you are using the correct superuser credentials.
  - If you have forgotten the password, try recreating the superuser by setting `create_superuser` to `true` and restarting the add-on.

## Support

If you have any questions or have found a bug, please create an issue on the GitHub repository:

[GitHub Repository](https://github.com/UkDC/StaySharp-Hassio-MariaDB)

## License

This project is distributed under the MIT License. See the [LICENSE](https://github.com/UkDC/StaySharp-Hassio-MariaDB/blob/main/LICENSE) file for details.


