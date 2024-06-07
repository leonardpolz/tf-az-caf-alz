# Firewall Management Repository

## Regel Dokumentation
Firewall Regeln werden in einer Excel Tabelle dokumentiert und via eines ID Parameters referenziert. (Dazu im Abschnitt Application Rule Collections & Network Rule Collections mehr)
Excel URL: "\\\ad.dom\dfs-dzpb$\DZ-Shared\P-0023_SLV-CLOUD\AP1\Connectivity\ConnectivityFirewallStatus.xlsx"

## Azure FW Struktur
1. Azure Firewall -> Diese Ressource stellt die Firewall selber dar und enhält die Einstellungen zur Azure Ressource selber und wird vom Platform Team innerhalb des Repositories "infra-alz-connectivity" verwaltet.
2. Azure Policy -> Die Azure Policy enthält die Regeln einer Firewall und steht mit ihr in einer 1 zu 1 Beziehung, diese Ressource wird ebenfalls im Repository "infra-alz-connectivity" verwaltet.
3. Rule Collection Groups -> Rule Collection Groups werden in unserem Konzpt für die einzelnen Workloads verwendet (wie z.B. Quantax) und in diesem Repository verwaltet. (Dazu unten mehr)
4. Rule Collections -> Rule Collections werden für die Gruppierung von Regeln für einzelne Ressourcen Endpoints eingesetzt, beispielsweise könnte eine Rule Collection die Ressource "stquantaxbackupdev"(Storage Account) darstellen. (Dazu unten mehr)
5. Rules -> Die Regeln in der Rule Collection stellen die einzelnen Freischaltungen auf die entsprechende Ressourcen da. Beispielsweise eine Freischaltung vom On-Premise Proxy auf einem festgelegten Port.

## Rule Collection Groups
Rule Collection Groups werden innerhalb des Ordners "fw-mgmt" verwaltet. In diesem Ordner liegen die einzlenen Rule Collection Groups als Files drin. Also z.B. findest du die Rule Collection fÜr den Workload "Quantax" in der Datei "config.rgc.quantax.tf". Das Naming "config" steht hier dafür das es sich in dem File um eine "config" handelt und "rcg" das es sich um eine Rule Collection Group handelt.
Innerhalb dieses Files sieht die Konfiguration dann wie Folgt aus:

./fw-mgmt/config.rcg.quantax.tf
```
locals {
  quantax = {
    name_config = {
      workload_name = "quantax"
    }

    priority = 1200

    application_rule_collections = [(...)]

    network_rule_collections = [(...)]
  }
}
```

Als erstes wird der für die Rule Collection Group automatisch generiert indem die variable "name_config" mit dem workload namen defeniert wird. Als nächstes wird die Priporität der Rule Collection Group definiert. (Aktuell verwende ich hier 100-er Schritte um noch Platz für alternative Workloads zu lassen). Als letztes werden daraufhin Application Rule Collections und Network Rule Collections für die einzlenen Ressourcen definiert. (Dazu unten mehr)

## Application Rule Collections
Application Rule Collections räpresentieren einzelne Ressourcen Endpoints wie Beispielsweise einen blob Endpoint von einem Storage Accounts und werden innerhalb von Rule Collection Groups angelegt. Ein Application Rule Collection kann z.B. so ausshen:

./fw-mgmt/config.rcg.quantax.tf
```
locals {
    (...)

    application_rule_collections = [
      {
        name_config = {
          resource_name = "sqlmiquantaxdev"
        }

        priority = 1000
        action   = "Allow"

        destination_fqdns = [
          "sqlmiquantaxdev.aec4de68045d.database.windows.net",
          "sqlmiquantaxdev.privatelink.aec4de68045d.database.windows.net"
        ]

        protocols = [
          {
            port = 1433
            type = "Mssql"
          }
        ]

        rules = [
          {
            name                 = "dzwdam01e"
            description          = "Dam -> sqlmiquantaxdev"
            mgmt_table_reference = "35g44mgc"

            source_addresses = [
              "10.32.64.241"
            ]
          },
          {
            name                 = "ch-group-vm"
            description          = "ch -> sqlmiquantaxdev"
            mgmt_table_reference = "p9440kx9"

            source_ip_groups = [
              var.ip_groups["ch_group_vm"].id
            ]
          },
          (...)
        ]
      },
      (...)
    ]
    (...)
  }
}
```

Im ersten Schritt wird wieder ein Name definiert, dieser wird wieder automatisch nach Naming Convention anhand der Variable name_config erstellt. In diesem Fall ist es die Ressource "sqlmiquantaxdev", optional ist es möglich einen zusätzlichen Parameter namens "id" zu definieren. Dies ist manchmal nötig weil einge Ressourcen wie z.b. ein Storage Account mehrere Endpoint brauchen, auf welche mit verscheidenen Protokollen zugegriffen wird.

## Network Rule Collections
Network Rules Collections stellen wieder einzelne Ressourcen Endpoints da, Application Rules unterstützen zur Zeit nur die Protokolle Http, Https und Mssql. Für Freischaltungen wie z.B. für einen SMB Fileshare muss deswegen eine Network Rule angelegt werden. Ein Network Rule Collection kann z.B. so aussehen:

./fw-mgmt/config.rcg.quantax.tf
```
locals {
  quantax = {
    name_config = {
      workload_name = "quantax"
    }

    priority = 1300

    application_rule_collections = [ 
      (...)
    ]

    network_rule_collections = [
      name_config = {
        resource_name   = "stquantaxbackupdev"
        endpoint_suffix = "file"
      }

      action                = "Allow"
      priority              = 1000
      protocols             = "TCP"
      destination_ports     = 445
      destination_fqdns     = "stquantaxbackupdev.core.windows.net"

      rules = [
        {
          name                 = "proxy"
          description          = "proxy -> stquantaxbackupdev, smb access"
          mgmt_table_reference = "p9440sx9"
          source_addresses     = optional(set(string))
          source_ip_groups     = optional(set(string))
        },
        (...)
      ]
    ]
  }
}
```

## Hinzufügen von neuen Workloads
Wenn ein neuer Workload/Rule Collection Group angelegt wird, also wie z.B. "quantax" oder "aro" muss hierfür ein ein neuer File mit diesem Schema anagelegt werden: "config.ipg.<workload_name>.tf". 
In dieser Datei wird der Workload dann so wie in den oberen beispielen an. Um die Registrierung abzuschliessen muss der Workload dann zusätlich in der "outputs.tf" referenziert werden.


./fw-mgmt/outputs.tf
```
output "workloads" {
  value = [
    local.platform,
    local.onpremise,
    local.quantax,
    local.aro,
    local.siem,
    local.sap,
  ]
}
```

## IP-Groups
IP-Groups werden in dem File "config.ipg.ip-groups.tf" angelegt. Hier ist eine ein Beispielkonfiguration:

./fw-mgmt/config.ipg.ip-groups.tf
```
locals {
  ip_groups = [
    {
      terraform_id = "ch_group_vm"

      name_config = {
        workload_name = "chgroupvm"
        environment   = "core"
      }

      cidrs = [
        "172.31.13.25",    // CH-Server-VA1
        "172.31.13.29",    // CH-Server VA2 
        "172.31.13.33",    // CH-Server VA3
        "172.31.13.28",    // CH-Server VA4
        "172.31.13.26",    // CH-Server VA5
        "172.31.13.30",    // CH-Server VA8
        "192.168.112.106", // CH-Server VB1
        "192.168.112.101", // CH-Server VB2 
        "192.168.112.111", // CH-Server VB3
        "192.168.112.104", // CH-Server VB4
        "192.168.112.102", // CH-Server VB8
      ]
    },
    {
      terraform_id = "proxy_onprem"

      name_config = {
        workload_name = "proxyonprem"
        environment   = "core"
      }

      cidrs = [
        "192.168.1.219",  // Proxy Node 1
        "192.168.1.220",  // Proxy Node 2
        "192.168.1.221",  // Proxy Node 3
        "192.168.1.222",  // Proxy Node 4
      ]
    }
  ]
}
```

Ip Groups können aus den den Regeln aus der variables.tf referenziert werden. Diese Referenz bezieht sich immer auf die "terraform_id" welche in den IP Groups definiert wird.

./fw-mgmt/config.ipg.ip-groups.tf
```
locals {
  ip_groups = [
    {
      terraform_id = "ch_group_vm"

      name_config = {
        workload_name = "chgroupvm"
        environment   = "core"
      }

      cidrs = [
        "172.31.13.25",    // CH-Server-VA1
        "172.31.13.29",    // CH-Server VA2 
        "172.31.13.33",    // CH-Server VA3
        "172.31.13.28",    // CH-Server VA4
        "172.31.13.26",    // CH-Server VA5
        "172.31.13.30",    // CH-Server VA8
        "192.168.112.106", // CH-Server VB1
        "192.168.112.101", // CH-Server VB2 
        "192.168.112.111", // CH-Server VB3
        "192.168.112.104", // CH-Server VB4
        "192.168.112.102", // CH-Server VB8
      ]
    },
  ]
}
```

./fw-mgmt/config.ipg.ip-groups.tf
```
(...)
  {
    name                 = "ch-group-vm"
    description          = "ch -> sqlmiquantaxdev"
    mgmt_table_reference = "p9440kx9"

    source_ip_groups = [
      var.ip_groups["ch_group_vm"].id # <- Referenz auf "terraform_id" von IP Group
    ]
  },
(...)
```

## Veralterte Ressourcen
Ressourcen aus dem alten Stand welche nicht dem aktuellen Naming und/oder dem Konfigurationsschema entsprechen befinden sich in besonderen files. IP-Groups befinden sich in "deprecated.config.ipg.ip-groups.tf",
veraltete Network Rules befinden sich innerhalb des Home-Directory in dem File "rcg.deprecated.tf".