class Player{
  String name;
  // String id;
  int balance;

  setName(String value) => name = value;
  setBalance(int value) => balance = value;
  setPlayer(Player player) {
    name = player.name;
    balance = player.balance;
  }

  Player(
    this.name, {
    this.balance = 0,
    // String id,
  });

  // factory Player.fromMap(Map<String, dynamic> data) {
  //   final Player tmp = Player.init();
  //   return Player(
  //     data['name'] ?? tmp.name,
  //     balance: data['balance'] ?? tmp.balance,
  //     // id: data['id'],
  //   );
  // }

  // Map<String, dynamic> toMap() => {
  //       'id': id,
  //       'name': name,
  //       'balance': balance,
  //     };

  // factory PlayerModel.fromArray(List<dynamic> data) {
  //   final PlayerModel tmp = PlayerModel.init();
  //   return PlayerModel(
  //     data[1] ?? tmp.name,
  //     balance: data[2] ?? tmp.balance,
  //     id: data[0],
  //   );
  // }

  // List<dynamic> toArray() => [id, name, balance];

  Player.init()
      : this.name = "",
        this.balance = 0;
        // this.id = "";

  bool get active => name.isNotEmpty;

  void balanceChange(int amount) => this.balance += amount;
  void balanceEmpty() => this.balance = 0;

  @override
  String toString() {
    return 'Player { name: $name, balance: $balance }';
  }
}