
Effect = Class {
    init = function(self, name, science, mineral, research)
        self.name = name
        self.science = science -- one time
        self.mineral = mineral -- every time its processed
        self.sampled = false
        self.researched = false
        self.research = research
    end
}

function Effect:research()
    self.research(self)
end
