# Desafío Cepas2 🚀

Para realizar este desafío debes haber estudiado previamente todo el material
disponibilizado correspondiente a la unidad.

### Pre-requisitos 📋
Se requiere la finalización del Desafío Cepas1

# Parte 1 📦 

  - Como ya sabemos, a Peter le gusta catar vinos y te solicitó ayuda para diseñar un     sistema que le permitiera guardar los vinos que ha ido probando.
  En esta ocasión, Peter quiere compartir la lista de vinos que ha ido probando.
    1. Peter necesita que sus amigos tengan una cuenta para poder acceder, ya que nadie puede ver la lista de vinos sin estar logueado.
    2. Sólo Peter puede agregar cepas y vinos, sus amigos sólo pueden ver la lista de vinos que ha probado.

Para resolver esta parte se utilizará devise para obtener el modelo de User y a este agregar un campo admin.
Se crea un controlador HOME con la vista index y se edita el archivo routes.rb asignando el POST root a home#index

```sh
rails g controller home index
root to: "home#index"
```
Para realizar el sistema de autenticación (sign_up, log_out, log_in), se usará la gema Devise, lo primero que se debe hacer es agregar la gema en el Gemfile y se ejecuta el bundle en la terminal para actualizar todas las gemas del proyecto
```sh
gem 'devise'
```
Se ejecuta el bundle para actualizar todas las gemas del proyecto
```sh
bundle
```
Por último, se instala la gema Devise realizando los pasos que aparecen al ejecutar el comando
```sh
rails g devise:install
```
Se asigna Devise a User, se verifica los campos generados y se inicia la migración
```sh
rails g devise User
rails db:migrate
```
Se agrega un nuevo campo al usuario **admin** de tipo **booleano**
```sh
rails g migration AddAdminToUser admin:boolean
```
Se verifica que los datos estan correctos y se genera la migración 
```sh
rails db:migrate
```
Para que solo los amigos de Peter puedan ver el listado de vinos y Peter sea el único en editar se debe agregar el callback `before_action :authenticate_user!` en el controlador **wines_controller.rb**
```sh
class WinesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_wine, only: %i[ show edit update destroy ]

  # GET /wines or /wines.json
  def index
    @wines = Wine.all
  end
 ...
```
En el archivo `views/home/index.html.erb` se agrega dos condicionales:
1. Para que solo puedan ver la página los amigos registrados
2. Para que solo el administrador pueda crear vinos y cepas
```sh
<<h1>Wines</h1>

<table class="table table-striped">
  <thead>
    <tr>
      <th>Name</th>
      <th colspan="3"></th>
    </tr>
  </thead>

  <tbody>
    <% @wines.each do |wine| %>
      <tr>
        <td> <%= wine.name %> </td>
        <td>
        <ul>
        <% assemblies = wine.assemblies.sort_by{|e| -e.strain.name} %>
        <% assemblies.each do |assembly| %>
        <li> The wine has (<%= assembly.percentage %>%) from strain <%= assembly.strain.name %></li>
        <% end %>
        </ul>
        </td>
        <td><%= link_to 'Show', wine %></td>
        <td><%= link_to 'Edit', edit_wine_path(wine) %></td>
        <td><%= link_to 'Destroy', wine, method: :delete, data: { confirm: 'Are you sure?' } %></td>
      </tr>
    <% end %>
  </tbody>
</table>

<br>
<% end %>
<% if current_user.admin? %>
<%= link_to 'New Wine', new_wine_path %> | <%= link_to 'New strain', new_strain_path %>
<% end %>
```
 
# Parte 2 📦 

  - Cada vino ha sido evaluado por un grupo de enólogos y les han dado una nota en escala de 1 a 100. Los enólogos trabajan en revistas especializadas y muchas veces trabajan en más de una de ellas cumpliendo uno de los siguientes cargos: Editor, Writer, Reviewer. Un enólogo puede cumplir los tres cargos al mismo tiempo en la misma revista.
    1.  Peter necesita ver la nota que los enólogos han puesto al vino en una columna distinta, junto al porcentaje y nombre de la cepa de un vino
    2. Peter almacenará en su sistema los datos de los enólogos, desde sus datos personales (nombre, edad y nacionalidad) hasta donde trabajan.
    3. Al editar un vino, Peter asignará la nota del vino y los enólogos que lo calificaron, ordenados por su edad.

Se crea un scaffold de winemaker con los siguientes atributos: name, old, nationality, work, is_editor, is_writer, is_reviewer (los tres últimos de tipo booleanos). La migración debería verse así:
```sh
create_table "winemakers", force: :cascade do |t|
    t.string "name"
    t.integer "old"
    t.string "nationality"
    t.string "work"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "is_editor"
    t.boolean "is_writer"
    t.boolean "is_reviewer"
  end
```
Se crea un modelo `critics` con el atributo scrore y asociando a la tabla **wines** y **winemaker**
```sh
rails g model critic scrore:integer wine:references winemaker:references
```
Al ejecutar la migración el esquema debe verse así:
```sh
create_table "critics", force: :cascade do |t|
    t.bigint "wine_id", null: false
    t.bigint "winemaker_id", null: false
    t.integer "score"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["wine_id"], name: "index_critics_on_wine_id"
    t.index ["winemaker_id"], name: "index_critics_on_winemaker_id"
  end
```
Se crea la asociación en los modelos **wine.rb**, **winemaker.rb** y **critics.rb**
```sh
class Critic < ApplicationRecord
  belongs_to :wine
  belongs_to :winemaker
end

class Winemaker < ApplicationRecord
    has_many :critics
    has_many :wines, through: :critics
end


class Wine < ApplicationRecord
    has_many :assemblies,  dependent: :destroy
    has_many :strains, through: :assemblies,  dependent: :destroy
    has_many :critics
    has_many :winemakers, through: :critics
    has_and_belongs_to_many :winemakers
    accepts_nested_attributes_for :assemblies, :critics
end

```
Para poder editar el vino, se debe cambiar de la vista parcial  `_assembly_fields.html.erb` el **select** por **collection_select** recibiendo las instancias desde el controlador **:id** y **name**
```sh
<div class="form-group">
    <%= f.label :strain_id, "Add a strain" %>
    <%= f.collection_select :strain_id, Strain.order(:name), :id, :name,{ include_blank: true},{class: 'form-control'} %>
</div>
<div class="form-group">
    <%= f.label :percentage, 'Percentage' %>
    <%= f.number_field :percentage,class: 'form-control' %>
</div>
```
En el controlador `wine_controller.rb` se edita el método **edit** asignandole a la instancia **strain** la búsqueda del **:id**
```sh
class WinesController < ApplicationController
  ...
  # GET /wines/1/edit
  def edit
    @strains = Strain.find(params[:id])
  end
...
end
```
Para agregar las notas y los enologos de los respectivos vinos, se crea un nuevo formulario en la vista `views/wines` la cual se llamará **form_edit.html.erb** en la cual se copiara y pegará el mismo formulario de **form.html.erb** de la misma vista y se agregará los siguientes campos:
```sh
...
  <div class="field" id="critics">
  <%= form.fields_for :critics do |ff| %>
    <%= render 'critic_fields', :f => ff %>
  <% end %>
  </div>
  
  <div class="links">
    <%= link_to_add_association 'Add another critics', form, :critics %>
  </div>
...
```
Se crea la vista parcial `_critics.html.erb`
```sh
<div class="form-group">
    <%= f.label :winemaker_id, "Add a Winemaker" %>
    <%= f.collection_select :winemaker_id, Winemaker.order(:name), :id, :name,{ include_blank: true},{class: 'form-control'} %>
</div>
<div class="form-group">
    <%= f.label :score, 'Score' %>
    <%= f.number_field :score, class: 'form-control' %>
</div>
```
Para que se pueda ver los enologos ordenados ascendentemente por edad y las notas en el home, se edita la vista `views/wines/index.html.erb` la cual debe quedar de la siguiente manera
```sh
p id="notice"><%= notice %></p>

<h1>Wines</h1>

<table class="table table-striped">
  <thead>
    <tr>
      <th>Name</th>
      <th> Assembly</th>
      <th>Critics</th>
      <th colspan="3"></th>
    </tr>
  </thead>

  <tbody>
    <% @wines.each do |wine| %>
      <tr>
        <td> <%= wine.name %> </td>
        <td>
        <ul>
        <% assemblies = wine.assemblies.sort_by{|e| -e.strain.name} %>
        <% assemblies.each do |assembly| %>
        <li> The wine has (<%= assembly.percentage %>%) from strain <%= assembly.strain.name %></li>
        <% end %>
        </ul>
        </td>
        <td>
        <ul>
        </ul>
        <% critics = wine.critics.sort_by{|e| e.winemaker.old} %>
        <% critics.each do |critic| %>
          <li><%= critic.winemaker.name %>'s score is <%= critic.score %></li>
        <% end %>
        </td>
        <td><%= link_to 'Show', wine %></td>
        <td><%= link_to 'Edit', edit_wine_path(wine) %></td>
        <td><%= link_to 'Destroy', wine, method: :delete, data: { confirm: 'Are you sure?' } %></td>
      </tr>
    <% end %>
  </tbody>
</table>

<br>

<% if current_user.admin? %>
  <%= link_to 'New Wine', new_wine_path %> | <%= link_to 'New strain', new_strain_path %>
<% end %>
```
Por último, se agrega el enlace de **winemaker** en el navbar `shared/_header.html.erb` para ver y crear nuevos enólogos 
```sh
<section id="header">
      <div class="inner">
					<span class="fas fa-wine-glass-alt"></span>
					<h1>La Strada del Vino.</h1>
				</div>
        <nav class="navbar navbar-expand-sm  sticky-top navbar-dark py-4 bg-transparent">
    <div class="mx-auto d-sm-flex d-block flex-sm-nowrap">
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarsExample11" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse text-center" id="navbarsExample11">
            <ul class="navbar-nav">
              <% if current_user %>
                <li class="nav-item"> <a class="nav-link"  <%= link_to 'Home', root_path %></a></li>
                <li class="nav-item"> <a class="nav-link"  <%= link_to 'Winemakers',  winemakers_path %></a></li>
                <li class="nav-item"> <a class="nav-link"  <%= link_to 'Sign out', destroy_user_session_path, method: :delete %></a></li>
              <% else %>
                <li class="nav-item"> <a class="nav-link"  <%= link_to 'Log in', new_user_session_path %></a></li>
                <li class="nav-item"> <a class="nav-link"  <%= link_to 'Sign in', new_user_registration_path %></a></li>
              <% end %>
            </ul>
        </div>
    </div>
    
</nav>
</section>
```
# Parte 3 📦 

  - Queremos que ante futuras mejoras, podamos identificar posibles fallos en nuestro sistema. 
  Crearemos una serie de tests para controladores y modelos.
Crearás specs con Rspec y se validará :
    - Identificar cuál modelo testear.
    - Que las cepas no pueden tener el mismo nombre.
    - Una cepa no puede tener un nombre vacío, probar 3 casos
        - nombre = nil
        - nombre = “ ”
        - nombre “Carmenere”
    
    En el controlador se testeará:
    - Identificar cual controlador testear.
    - Asegurar que la vista index está mostrando vinos.
    - La vista index y show renderizan el template correcto.
 
El modelo al cual se hará el test será **strain.rb**
Para realizar los test se debe instalar la gema `gem 'rspec-rails'` en el Gemfile, se genera el test unitario **strain** de la siguiente manera:
```sh
rails generate rspec:model strain
```
Para que las cepas no tengan el mismo nombre, se debe agregar `validates :name, presence: true` en el modelo **strain.rb** y en el `spec/model/strain_spec.rb` se debe agregar lo siguiente
```sh
require 'rails_helper'

RSpec.describe Strain, type: :model do
  describe "Validations names" do 
    it 'validates uniqueness name' do
      expect(Strain.validates_uniqueness_of(:name))
    end
  end
end
```
Para que validar que las cepas no tengan campos vacíos:
```sh
describe "Una cepa no puede tener un nombre vacío" do 
    it 'validates name not empty' do
      strain  = Strain.new(name: "")
      expect(strain).to_not be_valid
    end
  end

  describe "Una cepa no puede tener un nombre vacío" do 
    it 'validates name not nil' do
      strain  = Strain.new(name: nil)
      expect(strain).to_not be_valid
    end
  end
  
  describe "Una cepa no puede tener un nombre vacío" do 
    it 'validates name carmenere' do
      strain  = Strain.new(name: "Carmenere")
      expect(strain).to be 
    end
  end
```

El controlador al cual se le hará test es a **wines_controller.rb** 
Para asegurar que la vista index está mostrando vinos.
```sh
require 'rails_helper'
RSpec.describe WinesController, type: :controller do
    describe "GET index" do
        it "assigns @wines" do
            wine = Wine.create(name: "Buen Vino")
            get :index
            expect(assigns(:wine))==([wine])
        end
    end
end
```
Por último, la vista index y show renderizan el template correcto:
```sh
it "renders the index template" do
    get :index
    expect(response).to have_http_status(302)
end
it "renders the show template" do
    get(:show, params:{id: 5})
    expect(response).to have_http_status(302)
end
```
Se pone `have_http_status(302)` porque no se tiene un usurio para iniciar sesion, así que obliga a redireccionar.
# Construido con 🛠️

* Ruby [2.6.6] - Lenguaje de programación usado
* Rails [6.0.3.4]  - Framework web usado
* Bootstrap [4.5.3] - Framework de CSS usado

## Autores ✒️

* **Lina Sofía Vallejo Betancourth** - *Trabajo Inicial y documentación* - [linav92](https://github.com/linav92)


## Licencia 📄

Este proyecto es un software libre. 
