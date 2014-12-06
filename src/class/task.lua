
Task = Class {
    init = function(self, text, desc, eval, payoff)
        self.text = text
        self.desc = desc
        self.eval = eval
        self.payoff = payoff
        self.dt = 5
        self.active = false
        self.finished = false
    end
}

