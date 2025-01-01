resource "null_resource" "local_command_trigger" {
  depends_on = [module.ec2_instance]

  provisioner "remote-exec" {
    connection {
      type = "ssh"
      host = module.ec2_instance.public_dns
      user = "ubuntu"
      private_key = file("${var.ec2_key_name}.pem")
    }

    inline = [
      "echo 'connected!'",
      "sudo apt update",
      "curl -fsSL https://tailscale.com/install.sh | sh",
      "echo 'net.ipv4.ip_forward = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf",
      "echo 'net.ipv6.conf.all.forwarding = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf",
      "sudo sysctl -p /etc/sysctl.d/99-tailscale.conf",
      "sudo tailscale up --advertise-exit-node"
    ]
  }
}