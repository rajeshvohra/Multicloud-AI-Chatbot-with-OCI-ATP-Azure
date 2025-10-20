module "oci" {
  source               = "../../modules/oci"
  oci_tenancy_ocid     = var.oci_tenancy_ocid
  oci_user_ocid        = var.oci_user_ocid
  oci_fingerprint      = var.oci_fingerprint
  oci_private_key_path = var.oci_private_key_path
  oci_region           = var.oci_region
  oci_compartment_id   = var.oci_compartment_id
  adb_admin_password   = var.adb_admin_password
}

module "azure" {
  source                = "../../modules/azure"
  azure_subscription_id = var.azure_subscription_id
  azure_tenant_id       = var.azure_tenant_id
}
