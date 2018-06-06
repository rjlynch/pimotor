ROUTES = {
  '/' => {
    klass: MotorInstructionsController,
    methods: { 'GET' => :show, 'POST' => :create }
  }
}
