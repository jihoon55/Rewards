resource "aws_dynamodb_table" "Attendance" {
  name = "attendance"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "id"

  attribute {
    name = "id"
    type = "N"
  }
}

resource "aws_dynamodb_table_item" "Attendance_1" {
  table_name = aws_dynamodb_table.Attendance.name
  hash_key   = aws_dynamodb_table.Attendance.hash_key

  item = jsonencode({
  "id" : {
    "N" : "1"
 }
  "date" : {
    "N" : "3"
  },
  "user_id" : {
    "S" : "1"
  },
})
}

resource "aws_dynamodb_table_item" "attendance_2" {
  table_name = aws_dynamodb_table.Attendance.name
  hash_key   = aws_dynamodb_table.Attendance.hash_key

  item = jsonencode({
  "id" : {
    "N" : "2"
 }
  "date" : {
    "N" : "3"
  },
  "user_id" : {
    "S" : "3"
  },
})
}

resource "aws_dynamodb_table_item" "attendance_3" {
  table_name = aws_dynamodb_table.Attendance.name
  hash_key   = aws_dynamodb_table.Attendance.hash_key

  item = jsonencode({
  "id" : {
    "N" : "3"
 }
  "date" : {
    "N" : "5"
  },
  "user_id" : {
    "S" : "2"
  },
})
}

resource "aws_dynamodb_table_item" "Attendance_4" {
  table_name = aws_dynamodb_table.Attendance.name
  hash_key   = aws_dynamodb_table.Attendance.hash_key

  item = jsonencode({
  "id" : {
    "N" : "4"
 }
  "date" : {
    "N" : "5"
  },
  "user_id" : {
    "S" : "4"
  },
})
}

resource "aws_dynamodb_table" "Products" {
  name = "Products"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "id"

  attribute {
    name = "id"
    type = "N"
  }
}

resource "aws_dynamodb_table_item" "Product_1" {
  table_name = aws_dynamodb_table.Products.name
  hash_key   = aws_dynamodb_table.Products.hash_key

  item = jsonencode({
  "id" : {
    "N" : "1"
 }
  "condition" : {
    "N" : "10"
  },
  "name" : {
    "S" : "nike"
  },
  "remain" : {
    "N" : "7"
  },  
})
}

resource "aws_dynamodb_table_item" "Product_2" {
  table_name = aws_dynamodb_table.Products.name
  hash_key   = aws_dynamodb_table.Products.hash_key

  item = jsonencode({
  "id" : {
    "N" : "2"
 }
  "condition" : {
    "N" : "15"
  },
  "name" : {
    "S" : "adidas"
  },
  "remain" : {
    "N" : "20"
  },  
})
}

resource "aws_dynamodb_table_item" "Product_3" {
  table_name = aws_dynamodb_table.Products.name
  hash_key   = aws_dynamodb_table.Products.hash_key

  item = jsonencode({
  "id" : {
    "N" : "3"
 }
  "condition" : {
    "N" : "15"
  },
  "name" : {
    "S" : "newbalance"
  },
  "remain" : {
    "N" : "25"
  },  
})
}

resource "aws_dynamodb_table" "Rewards" {
  name = "Rewards"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "id"

  attribute {
    name = "id"
    type = "N"
  }
}

resource "aws_dynamodb_table_item" "Reward_1" {
  table_name = aws_dynamodb_table.Rewards.name
  hash_key   = aws_dynamodb_table.Rewards.hash_key

  item = jsonencode({
  "id" : {
    "N" : "1"
 }
  "product_id" : {
    "N" : "3"
  },
  "reward_time" : {
    "N" : "17"
  },
  "user_id" : {
    "S" : "4"
  },  
})
}

resource "aws_dynamodb_table_item" "Reward_2" {
  table_name = aws_dynamodb_table.Rewards.name
  hash_key   = aws_dynamodb_table.Rewards.hash_key

  item = jsonencode({
  "id" : {
    "N" : "2"
 }
  "product_id" : {
    "N" : "2"
  },
  "reward_time" : {
    "N" : "15"
  },
  "user_id" : {
    "S" : "3"
  },  
})
}

resource "aws_dynamodb_table_item" "Reward_3" {
  table_name = aws_dynamodb_table.Rewards.name
  hash_key   = aws_dynamodb_table.Rewards.hash_key

  item = jsonencode({
  "id" : {
    "N" : "3"
 }
  "product_id" : {
    "N" : "1"
  },
  "reward_time" : {
    "N" : "3"
  },
  "user_id" : {
    "S" : "1"
  },  
})
}

resource "aws_dynamodb_table_item" "Reward_4" {
  table_name = aws_dynamodb_table.Rewards.name
  hash_key   = aws_dynamodb_table.Rewards.hash_key

  item = jsonencode({
  "id" : {
    "N" : "4"
 }
  "product_id" : {
    "N" : "6"
  },
  "reward_time" : {
    "N" : "7"
  },
  "user_id" : {
    "S" : "2"
  },  
})
}

resource "aws_dynamodb_table" "Users" {
  name = "users"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "id"

  attribute {
    name = "id"
    type = "N"
  }
}

resource "aws_dynamodb_table_item" "User_1" {
  table_name = aws_dynamodb_table.Users.name
  hash_key   = aws_dynamodb_table.Users.hash_key

  item = jsonencode({
  "id" : {
    "N" : "1"
 }
  "username" : {
    "S" : "sang"
  },
  "count" : {
    "N" : "3"
  },
  "user_point" : {
    "N" : "40000"
  },  
})
}

resource "aws_dynamodb_table_item" "User_2" {
  table_name = aws_dynamodb_table.Users.name
  hash_key   = aws_dynamodb_table.Users.hash_key

  item = jsonencode({
  "id" : {
    "N" : "2"
 }
  "username" : {
    "S" : "hoon"
  },
  "count" : {
    "N" : "5"
  },
  "user_point" : {
    "N" : "20000"
  },  
})
}

resource "aws_dynamodb_table_item" "User_3" {
  table_name = aws_dynamodb_table.Users.name
  hash_key   = aws_dynamodb_table.Users.hash_key

  item = jsonencode({
  "id" : {
    "N" : "3"
 }
  "username" : {
    "S" : "geon"
  },
  "count" : {
    "N" : "3"
  },
  "user_point" : {
    "N" : "30000"
  },  
})
}

resource "aws_dynamodb_table_item" "User_4" {
  table_name = aws_dynamodb_table.Users.name
  hash_key   = aws_dynamodb_table.Users.hash_key

  item = jsonencode({
  "id" : {
    "N" : "4"
 }
  "username" : {
    "S" : "tae"
  },
  "count" : {
    "N" : "5"
  },
  "user_point" : {
    "N" : "40000"
  },  
})
}