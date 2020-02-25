
resource "aws_instance" "web" {
  ami               = "ami-00b3aa8a93dd09c13"
  instance_type     = "t2.micro"
  subnet_id         = "${aws_subnet.pub-sub.*.id[0]}"
  source_dest_check = false
  key_name          = "Nat instance"

  tags = {
    Name = "nat instance"
  }
}



resource "aws_instance" "webserver" {
  ami           = "ami-0d2692b6acea72ee6"
  instance_type = "t2.micro"
  subnet_id     = "${aws_subnet.pub-sub.*.id[1]}"
  key_name      = "Nat instance"
  user_data     = "${file("apache.sh")}"

  tags = {
    Name = "webserver"
  }
}
