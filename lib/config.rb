module ObtainableConfig
  def self.bicycle_config
    [
      ['tires', '24"', 1, 0.10],
      ['chain', '6-speed', 1, 0.1],
      ['gears', '6-speed', 2, 0.09],
      ['frame', 'road bike', 1, 0.05],
      ['brakes', 'old and rusted', 0, 0.09]
    ]
  end

  def self.rollerblades_config
    [
      ['wheels', 'recreational', 1, 0.02],
      ['boot', 'recreational', 0],
      ['bearings', 'ABEC rating 5', 1, 0.07]
    ]
  end

  def self.skateboard_config
    [
      ['deck', 'shortboard', 1, 0.08],
      ['wheels', 'low-grade', 1, 0.03],
      ['bearings', 'ABEC rating 5', 1, 0.07]
    ]
  end
end
