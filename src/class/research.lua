
Research = Class {
    init = function(self, id, name, desc, requires, enables)
        self.id = id
        self.name = name
        self.desc = desc
        self.requires = requires
        self.enables = enables
        self.active = false
    end
}

