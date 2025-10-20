variable "oci_tenancy_ocid" { type = string }
variable "oci_user_ocid" { type = string }
variable "oci_fingerprint" { type = string }
variable "oci_private_key_path" { type = string }
variable "oci_region" { type = string, default = "us-phoenix-1" }
variable "oci_compartment_id" { type = string }
variable "adb_admin_password" { type = string, sensitive = true }
