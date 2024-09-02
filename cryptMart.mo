import Buffer "mo:base/Buffer";
import {toText} "mo:base/Nat";

actor CrypMart {
  type Product = {
    name: Text;
    productId: Nat;
    price: Nat;
    description: Text;
    category: Category;
    quantity: Nat;
  };

  type Category = {
    #Electronics;
    #Groceries;
    #Toiletries;
    #Clothes;
    #Furniture;
    #Sport;
  };

  var productDB = Buffer.Buffer<Product>(0);
  let DbHeaders = ["Name","ProductID","Price","Description", "Category", "Quantity"];

  public func AddProduct(product:Product): async Text{
    let bind = productDB.add(product);
    return "succesfully added product";
  };
  
  public query func toCSV(): async Text{
    var csvText = "";

    for(index in DbHeaders.keys()) {
      let header = DbHeaders[index];

      if(index == DbHeaders.size() -1){
        csvText #= header # "\n";
      } else {
        csvText #= header # ","
      };

    };

    let productSnapshot = Buffer.toArray(productDB);
    for(product in productSnapshot.vals()){
      csvText #= product.name # ",";
      csvText #= toText(product.productId) # ",";
      csvText #= toText(product.price) # ",";
      csvText #= product.description # ",";
      switch(product.category) {
        case(#Electronics) {csvText #= "Electronics" # "\n"};
        case(#Groceries) {csvText #= "Groceries" # "\n"};
        case(#Toiletries) {csvText #= "Toiletries" # "\n" };
        case(#Furniture) {csvText #= "Furniture" # "\n" };
        case(#Clothes) {csvText #= "Clothes" # "\n" };
        case(#Sport) {csvText #= "Sport" # "\n" };
      };
    };
    return csvText;
  };

  public query func getProductPrice(productName: Text): async Nat {
    let productSnapshot = Buffer.toArray(productDB);
    for (product in productSnapshot.vals()) {
      if (product.name == productName) {
        return product.price;
      }
    };
    return 0; 
  };

  public query func getProductQuantity(productName: Text): async Nat {
    let productSnapshot = Buffer.toArray(productDB);
    for (product in productSnapshot.vals()) {
      if (product.name == productName) {
        return product.quantity;
      }
    };
    return 0; 
  };
    
}
