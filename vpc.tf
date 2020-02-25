resource "aws_vpc" "my-vpc" {
  cidr_block       = "${var.vpc-cidr}"
  instance_tenancy = "${var.tenancy}"


  tags = "${var.vpc-tags}"
}

resource "aws_subnet" "pub-sub" {
  count                   = "${length(data.aws_availability_zones.available.names)}"
  vpc_id                  = "${aws_vpc.my-vpc.id}"
  cidr_block              = "${element(var.public-subnet-cidr, count.index)}"
  availability_zone       = "${element(data.aws_availability_zones.available.names, count.index)}"
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet"
  }
}

resource "aws_subnet" "pri-sub" {
  count             = 2
  vpc_id            = "${aws_vpc.my-vpc.id}"
  cidr_block        = "${element(var.pri-subnet-cidr, count.index)}"
  availability_zone = "${element(data.aws_availability_zones.available.names, count.index)}"
  tags = {
    Name = "pri-subnet"
  }
}

###########################################################

resource "aws_internet_gateway" "Igw" {
  vpc_id = "${aws_vpc.my-vpc.id}"

  tags = {
    Name = "for-public"
  }
}


resource "aws_route_table" "public-route" {
  vpc_id = "${aws_vpc.my-vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.Igw.id}"
  }


  tags = {
    Name = "public-route1"
  }
}

#public subnet association_id
resource "aws_route_table_association" "public-association" {
  count          = "${length(data.aws_availability_zones.available.names)}"
  subnet_id      = "${element(aws_subnet.pub-sub.*.id, count.index)}"
  route_table_id = "${aws_route_table.public-route.id}"
}

####private route table_mappings

resource "aws_route_table" "pri-route" {
  vpc_id = "${aws_vpc.my-vpc.id}"

  route {
    cidr_block  = "0.0.0.0/0"
    instance_id = "${aws_instance.web.id}"
  }

  tags = {
    Name = "pri-route"
  }
}

#private subnet association_id

resource "aws_route_table_association" "private-association" {
  count          = 2
  subnet_id      = "${element(aws_subnet.pri-sub.*.id, count.index)}"
  route_table_id = "${aws_route_table.pri-route.id}"
}
