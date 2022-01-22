$server = "IE11WIN7\SQLEXPRESS"
$tablequery = "SELECT name from sys.tables"

$databases = @(
    "AdjudicationPanel",
    "Ossc",
    "Osscahmlr",
    "ASADJ",
    "CARESTANDARDS",
    "CICAP",
    "WEBEDITORS",
    "EAT",
    "ETJR",
    "Imset",
    "IT",
    "Lands",
    "SENDIST",
    "Transport",
    "FVVA",
    "DCAFE"
)


foreach ($database in $databases) {

    $connectionTemplate = "Data Source={0};Integrated Security=SSPI;Initial Catalog={1};"
    $connectionString = [string]::Format($connectionTemplate, $server, $database)
    $connection = New-Object System.Data.SqlClient.SqlConnection
    $connection.ConnectionString = $connectionString

    $command = New-Object System.Data.SqlClient.SqlCommand
    $command.CommandText = $tablequery
    $command.Connection = $connection

    #Load up the Tables in a dataset
    $SqlAdapter = New-Object System.Data.SqlClient.SqlDataAdapter
    $SqlAdapter.SelectCommand = $command
    $DataSet = New-Object System.Data.DataSet
    $SqlAdapter.Fill($DataSet)
    $connection.Close()

    New-Item -ItemType directory -Path "C:\tribs-export\$($database)"

    foreach ($Row in $DataSet.Tables[0].Rows) {
        $queryData = "SELECT * FROM [$($Row[0])]"

        #Specify the output location of your dump file
        $extractFile = "C:\tribs-export\$($database)\$($Row[0]).csv"

        $command.CommandText = $queryData
        $command.Connection = $connection

        $SqlAdapter = New-Object System.Data.SqlClient.SqlDataAdapter
        $SqlAdapter.SelectCommand = $command
        $DataSet = New-Object System.Data.DataSet
        $SqlAdapter.Fill($DataSet)
        $connection.Close()

        $DataSet.Tables[0]  | Export-Csv $extractFile -NoTypeInformation
    }
}