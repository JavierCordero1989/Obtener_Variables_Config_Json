# Obtener Nodos XML a formato JSON

## Resumen
Esta tarea permitirá obtener los nodos con las etiquetas appSettings, connectionStrings, applicationSettings y endpoint, de un archivo XML, especialmente los archivos Web.config y App.config en soluciones .NET.

## Requisitos
Para ejecutar esta tarea, necesitará al menos Powershell v5 instalado en el agente.

## Parámetros
* **Archivo XML:** ruta del archivo XML del cual se desean obtener las variables. Importante resaltar que el archivo debe poseer nodos con las etiquetas `<appSettings>`, `<applicationSettings>`, `<endpoint>` y `<connectionStrings>`.
* **Nombre del archivo JSON:** nombre con el que se guardará el archivo con formato JSON resultante de obtener los nodos del archivo XML.

## Ejemplo de archivo XML
El archivo XML al que se le desee obtener los nodos anteriormente mencionados, debe poseer una estructura similar a la siguiente (no son necesarios todos los nodos):

```xml
<?xml version="1.0" encoding="utf-8"?>
<configuration>
  <system.web>
    <globalization uiCulture="es-CR" requestEncoding="utf-8" responseEncoding="utf-8" />
    <compilation debug="true" targetFramework="4.0" />
    <authentication mode="Windows" />
    <identity impersonate="false" />
  </system.web>
  <system.webServer>
    <validation validateIntegratedModeConfiguration="false" />
    <directoryBrowse enabled="true" />
  </system.webServer>
  <connectionStrings>
    <add name="cadenaConexion" connectionString="Data Source=VM-PRUEBAS-001\BASEDATOS; Initial Catalog=MY_DB;user id=user; password=password123" providerName="System.Data.SqlClient"/>
  </connectionStrings>
  <appSettings>
    <add key="Servidor" value="VM-PRUEBAS-001" />
    <add key="Username" value="Domain\User" />
    <add key="Password" value="Server123" />
  </appSettings>
    <client>
        <endpoint address="http://localhost/myService/myService1.asmx" binding="basicHttpBinding" bindingConfiguration="service1" contract="namespace.service1" name="service1" />

        <endpoint address="http://localhost/myService/myService2.asmx" binding="basicHttpBinding" bindingConfiguration="service2" contract="namespace.service2" name="service2" />
    </client>

    <applicationSettings>
      <setting name="ServicioUno" serializeAs="String">
        <value>http://localhost:8000/ServicioUno.asmx</value>
      </setting>
      <setting name="ServicioDos" serializeAs="String">
        <value>http://localhost:8000/ServicioDos.asmx</value>
      </setting>
  </applicationSettings>
</configuration>
```

## Ejemplo de archivo JSON resultante
El archivo en formato JSON que resulte del proceso, tendrá un formato similar al siguiente:

```json
{
    "appSettings": {
        "Username": "Domain\\User",
        "Password": "Server123",
        "Servidor": "VM-PRUEBAS-001"
    },
    "endpoint": {
        "service2": "http://localhost/myService/myService2.asmx",
        "service1": "http://localhost/myService/myService1.asmx"
    },
    "applicationSettings": {
        "ServicioUno": "http://localhost:8000/ServicioUno.asmx",
        "ServicioDos": "http://localhost:8000/ServicioDos.asmx"
    },
    "connectionStrings": {
        "cadenaConexion": "Data Source=VM-PRUEBAS-001\\BASEDATOS; Initial Catalog=MY_DB;user id=user; password=password123"
    }
}
```
