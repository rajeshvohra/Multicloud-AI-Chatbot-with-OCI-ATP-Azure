provider "oci" {
  tenancy_ocid     = var.oci_tenancy_ocid
  user_ocid        = var.oci_user_ocid
  fingerprint      = var.oci_fingerprint
  private_key_path = var.oci_private_key_path
  region           = var.oci_region
}

resource "oci_database_autonomous_database" "adb" {
  compartment_id           = var.oci_compartment_id
  db_name                  = "RAGCHATBOTDB"
  cpu_core_count           = 1
  data_storage_size_in_tbs = 1
  admin_password           = var.adb_admin_password
  display_name             = "RAG Chatbot ADB"
  license_model            = "LICENSE_INCLUDED"
  is_auto_scaling_enabled  = true
}

resource "oci_objectstorage_bucket" "documents" {
  compartment_id       = var.oci_compartment_id
  name                 = "ragchatbot-docs"
  public_access_type   = "NoPublicAccess"
}
