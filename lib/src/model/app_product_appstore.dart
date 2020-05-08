
class Store {
  final int createdAt;
  final int  updatedAt;
  final int  id; 
  final String  name; 
  final String  address; 
  final String  headerImageUrl;
  final String  otherImageUrl;
  final String  state;
  final String  country;
  final String  isoCode;
  final bool  active;
  final String  blockedReason;
  final int  owner;

  Store({this.createdAt,this.updatedAt, this.id, this.name, this.address, this.headerImageUrl, this.otherImageUrl,
    this.state,this.country, this.isoCode, this.active, this.blockedReason, this.owner});
}

/*
"store": {
        "createdAt": 1583398323910,
        "updatedAt": 1583398323910,
        "id": 1,
        "name": "May hill hotel",
        "address": "Lekki Phase 1",
        "headerImageUrl": "",
        "otherImageUrl": "",
        "state": "Lagos",
        "country": "Nigeria",
        "isoCode": "234",
        "active": true,
        "blockedReason": "",
        "owner": 1
      }

*/