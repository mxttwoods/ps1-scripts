# SQL Connection Variables - Change
$SQLServer = "SQLServerName.mydomain.local"
$SQLDBName = "Database_Name"
$SQLUsername = "SQLReaderUser"
$SQLPassword = "MySQLPassword"

# Where to save the output CSV file - Change
$OuputFile = "c:\scripts\SQL_Export.csv"

# Your SQL Query - Change
$SqlQuery = "SELECT
    rtrim(EmployeeNumber) as EmployeeNumber,
    rtrim(JobTitle) as JobTitle,
    rtrim(Department) as Department,
    rtrim(Company) as Company,
    rtrim(Location) as Location,
    rtrim(CostCentre) as CostCentre,
    rtrim(ManagerEmployeeNumber) as ManagerEmployeeNumber
  FROM [$SQLDBName].[dbo].[Employee_Basic]"

# Delete the output file if it already exists
If (Test-Path $OuputFile) {
  Remove-Item $OuputFile
}

Write-Host "INFO: Exporting data from $SQLDBName to $OuputFile" -foregroundcolor white -backgroundcolor blue

# Connect to SQL Server using non-SMO class 'System.Data':
$SqlConnection = New-Object System.Data.SqlClient.SqlConnection
$SqlConnection.ConnectionString = "Server = $SQLServer; Database = $SQLDBName; User ID = $SQLUsername; Password = $SQLPassword"

$SqlCmd = New-Object System.Data.SqlClient.SqlCommand
$SqlCmd.CommandText = $SqlQuery
$SqlCmd.Connection = $SqlConnection

$SqlAdapter = New-Object System.Data.SqlClient.SqlDataAdapter
$SqlAdapter.SelectCommand = $SqlCmd

$DataSet = New-Object System.Data.DataSet
$SqlAdapter.Fill($DataSet)
$SqlConnection.Close()

$DataSet.Tables[0] | Select-Object "EmployeeNumber", "JobTitle", "Department", "Company", "Location", "CostCentre", "ManagerEmployeeNumber" | Export-Csv $OuputFile
