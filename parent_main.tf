module "WinVM" {
  source = "git::https://github.com/Kunlesanni/TestModules"
  # version = "v2.0.0"
  nb_instances  = 1
  nb_data_disk  = 3
  vm_hostname   = "mimWebAppDB01u"
  rgdata        = "rg-236-MIM-Nonprod"
  vm_size       = "Standard_B2ms"
  Imgdefinition = "ISDWindowsServer2022"
  tags = {
    Terraform       = "True"
    Environment     = "uat"
    "SID-SSN"       = "236-MIM"
    RequestedBy     = "Daniel Lim"
    "Request Date"  = formatdate("DD MMM YYYY", timestamp())
    "Budget Code"   = "504946.100.156780"
    "Budget Owner"  = "ccaepur@ucl.ac.uk"
    "Business Unit" = "Infrastructure Applications & Services"
    Backup          = "Daily"
    Version         = "2"
    autostartstop   = "Extended Work Week (8am - 7pm)"
  }
}
