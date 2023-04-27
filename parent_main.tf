module "WinVM" {
  source = "git::https://github.com/Kunlesanni/TestModules"
  # version = "v2.0.0"
  nb_instances  = 5
  nb_data_disk  = 3
  vm_hostname   = "azw22b"
  rgdata        = "rg-998-TEST-Nonprod"
  vm_size       = "Standard_DS2_v2"
  Imgdefinition = "ISDWindowsServer2022"
  tags = {
    Terraform       = "True"
    Environment     = "Non Production"
    "SID-SSN"       = "998-Test"
    RequestedBy     = "Olakunle Sanni"
    "Request Date"  = formatdate("DD MMM YYYY", timestamp())
    "Budget Code"   = "123456.123.123456"
    "Budget Owner"  = "ccaeosa@ucl.ac.uk"
    "Business Unit" = "Test Services"
    Backup          = "Daily"
    Version         = "2"
    autostartstop   = "Work Week (9am - 5pm)"
  }
}
