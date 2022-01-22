function Invoke-SQL-Query() {
  $SqlQuery = "SELECT [EmployeeID]
              ,[LastName]
              ,[Title]
            FROM [Northwind].[dbo].[Employees]"
  $SQLServer = "localhost"
  $SQLDBName = "Northwind"
  $SQLUsername = "SA"
  $SQLPassword = "TheSecretPassword!"
  $OuputFile = "/Users/matthewwoods/Development/ps1/sql-query-results.csv"

  If (Test-Path $OuputFile) {
    Write-Warning "INFO: Output file already exists, removing it."
    Remove-Item $OuputFile
  }

  Write-Host "INFO: Exporting data from $SQLDBName to $OuputFile" # -foregroundcolor white -backgroundcolor blue
  $SqlConnection = New-Object System.Data.SqlClient.SqlConnection
  $SqlCmd = New-Object System.Data.SqlClient.SqlCommand
  $SqlAdapter = New-Object System.Data.SqlClient.SqlDataAdapter
  $DataSet = New-Object System.Data.DataSet

  Write-Host "INFO: Connecting to $SQLServer"
  $SqlConnection.ConnectionString = "Server = $SQLServer; Database = $SQLDBName; User ID = $SQLUsername; Password = $SQLPassword"
  $SqlCmd.Connection = $SqlConnection
  $SqlAdapter.SelectCommand = $SqlCmd

  try {
    Write-Host "INFO: Running query"
    Write-Host "INFO: $SqlQuery"
    $SqlConnection.Open()
    $SqlCmd.CommandText = $SqlQuery
    Write-Host "INFO: Populating DataSet"
    $SqlAdapter.Fill($DataSet)
    Write-Host "INFO: Closing connection"
    $SqlConnection.Close()
    if ($DataSet.Tables[0].Rows.Count -eq 0) {
      Write-Error "ERROR: DataSet is empty, exiting"
      exit 1
    }
    Write-Host "INFO: Writing data to $OuputFile"
    $DataSet.Tables[0] | Select-Object "EmployeeID", "LastName", "Title" | Export-Csv $OuputFile
    if ((Get-Content $OuputFile).Count -eq 0) {
      Write-Error "ERROR: $OuputFile is empty, exiting"
      exit 1
    }
    Write-Host "INFO: Exported data to $OuputFile"
  }
  catch {
    Write-Error "ERROR: $($_.Exception.Message)"
    Write-Error "ERROR: Exiting"
    exit 1
  }
}
Invoke-SQL-Query