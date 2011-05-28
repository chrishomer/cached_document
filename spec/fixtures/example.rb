class Example
  
  def firstname
    "John"
  end
  
  def lastname
    "Smith"
  end
  
  def address
    Address.new(city: "San Francisco", state: "CA", zip: "94108", line1: "59 Grant Ave", line2: "FL 2", name: "thredUP")
  end
  
  
  class Address
    attr_accessor :city, :state, :zip, :line1, :line2, :name
    def initialize(args)
      args.each do |k,v|
        self.send("#{k}=",v)
      end
      self
    end
  end
end
