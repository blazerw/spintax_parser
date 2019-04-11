class Token
  @kind : Int32 | Nil
  @value : Int32 | Nil

  Plus     = 0
  Minus    = 1
  Multiply = 2
  Divide   = 3

  Number   = 4

  LParen   = 5
  RParen   = 6

  End      = 7

  property :kind
  property :value

  def initialize
    @kind = nil
    @value = nil
  end

  def unknown?
    @kind.nil?
  end
end
