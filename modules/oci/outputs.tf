output "adb_connection_string" {
  description = "Connection string for the OCI Autonomous Database"
  value       = oci_database_autonomous_database.adb.connection_strings[0].all_connection_strings
}

output "oci_documents_bucket" {
  description = "OCI Object Storage bucket for documents"
  value       = oci_objectstorage_bucket.documents.name
}
