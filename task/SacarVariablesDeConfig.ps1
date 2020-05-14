function ObtenerDatosJson {
    param (
        [string]$llave_config,
        [string]$llave_json,
        [System.Object]$json_file,
        [System.Xml.XmlNode]$configFile
    )
    
    # Obtienen los nodos que coincidan con el parámetro $llave_config
    $config_content = $configFile | Select-Xml -XPath "//$llave_config" | Select-Object -ExpandProperty Node

    # Si se encontraron nodos con la llave, se entra al fi
    if($null -ne $config_content){

        # Se crea un objeto de tipo array o hashtable
        $json_content = @{}

        # Se pasan los datos de los nodos encontrados, a un array
        [array]$config_content_array = $config_content

        $tag = "name"
        $value = "connectionString"

        # Cambia la llave y el valor del XML, según el parámetro que se necesite transformar
        switch ($llave_json) {
            "connectionStrings" {
                $tag="name"
                $value= "connectionString"
            }
            "appSettings" {
                $tag="key"
                $value= "value"
            }
            "applicationSettings" {
                $tag="name"
                $value= "value"
            }
            "endpoint" {
                $tag="name"
                $value= "address"
            }
        }

        $variables_length = $config_content_array.Length

        # Se recorre cada registro encontrado para guardarlos en el array
        for($app=0; $app -lt $variables_length; $app++){
            $llave = $config_content_array[$app].$tag.Trim()
            $valor = $config_content_array[$app].$value.Trim()

            $json_content.Add($llave, $valor)
        }

        # Se guardan el arreglo de llaves-valores en un array, que posterior se guardará en un archivo
        $json_file.Add("$llave_json", $json_content)

        Write-Host "Tipo de variables: $($llave_json). Cantidad: $($variables_length)"
    }
    
}

$configFile = ".\endpoints.config"
$jsonFileName = ".\mis_variables"

$FilePath = $configFile

if( (Test-Path $FilePath) -eq $False) {
    Write-Host "El archivo no existe."
}
elseif( (!"$FilePath".ToUpperInvariant().EndsWith(".CONFIG")) -And (!"$FilePath".ToUpperInvariant().EndsWith(".XML"))){
    Write-Host "El archivo no tiene el formato correcto. Debe ser .config o .xml"
}
else {
    [xml]$fileContent = Get-Content -Path $FilePath

    $json_file = @{}

    # Se buscan las variables de los diferentes nodos 
    ObtenerDatosJson -llave_config "appSettings/add" -llave_json "appSettings" -json_file $json_file -configFile $fileContent
    ObtenerDatosJson -llave_config "setting" -llave_json "applicationSettings" -json_file $json_file -configFile $fileContent
    ObtenerDatosJson -llave_config "endpoint" -llave_json "endpoint" -json_file $json_file -configFile $fileContent
    ObtenerDatosJson -llave_config "connectionStrings/add" -llave_json "connectionStrings" -json_file $json_file -configFile $fileContent

    # Los datos encontrados se convierten en JSON
    $json_data = $json_file | ConvertTo-Json

    # Se guarda el archivo JSON
    New-Item -Force -Path "$jsonFileName.json" -ItemType File -Value $json_data
}