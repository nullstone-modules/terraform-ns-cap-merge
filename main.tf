variable "modules" {
  type        = list(map(any))
  description = "A list of modules that contain outputs that will be merged together into a single stream of outputs"
}

locals {
  all_keys_deep = [for m in var.modules : keys(m)]
  all_keys      = setunion(local.all_keys_deep...)
  outputs_deep  = { for k in local.all_keys : k => [for m in var.modules : lookup(m, k, null)] }
  outputs       = { for k, v in local.outputs_deep : k => flatten([for x in v : x if x != null]) }
}

output "outputs" {
  value = local.outputs
}
