module TextEffects
  extend ActiveSupport::Concern

  def parallax
    self.parallax? ? 'Activado' : 'desactivado'
  end

  def visible 
    self.visible? ? 'Si' : 'No'
  end

  def body_truncate
    self.body.to_s.truncate(25, omission: '... ')
  end
end