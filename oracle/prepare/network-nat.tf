
resource "oci_core_public_ip" "nat" {
  compartment_id = var.compartment_ocid
  lifetime       = "RESERVED"
  defined_tags   = merge(var.tags, { "Kubernetes.Type" = "infra" })

  lifecycle {
    ignore_changes = [
      defined_tags
    ]
  }
}

resource "oci_core_nat_gateway" "private" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.main.id
  display_name   = "main"
  public_ip_id   = oci_core_public_ip.nat.id
  defined_tags   = merge(var.tags, { "Kubernetes.Type" = "infra" })

  lifecycle {
    ignore_changes = [
      defined_tags
    ]
  }
}

resource "oci_core_route_table" "private" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.main.id
  display_name   = "private"
  defined_tags   = merge(var.tags, { "Kubernetes.Type" = "infra" })

  route_rules {
    network_entity_id = oci_core_nat_gateway.private.id
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
  }
  route_rules {
    network_entity_id = oci_core_service_gateway.main.id
    destination       = data.oci_core_services.object_store.services[0]["cidr_block"]
    destination_type  = "SERVICE_CIDR_BLOCK"
  }

  lifecycle {
    ignore_changes = [
      defined_tags
    ]
  }
}
