function Start-ETL {
  Write-Warning "ETL Started"
  $query = "SELECT * FROM [Northwind].[dbo].[Categories]"
  try {
    $DataTable = Invoke-Sqlcmd -Query $query -Username "SA" -Password "password!" -ErrorAction Stop -OutputAs DataTables -Verbose
    $DataTable | Export-Csv -Path "/Users/matthewwoods/Development/Categories.csv" -Delimiter "," -NoTypeInformation
  }
  catch {
    Write-Error "Error: $($_.Exception.Message)"
  }
}
Start-ETL
Write-Warning "ETL completed successfully"

$filename = "/Users/matthewwoods/Development/Categories.csv"
Invoke-Sqlcmd -Query "SELECT * FROM [Northwind].[dbo].[Categories]" -ServerInstance "localhost\SQL2019" | Export-Csv -Path $filename -NoTypeInformation

