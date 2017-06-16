# Rails Exporter 

Rails Exporter (CSV, XML, XLS, XSLX)

## How to install

Add it to your **Gemfile**: 
```ruby
gem 'rails-exporter'
```

Run the following command to install it:
```sh
$ bundle install
$ rails generate rails_exporter:install
```

## Generators

You can generate exporters `app/exporters/example_exporter.rb`

```sh
$ rails generate rails_exporter:exporter example
```

Generator will make a file with content like:

```ruby
class ExampleExporter < RailsExporter::Base

  exporter do
    column :name
    column :email
    column :price => :currency
    column :is_admin => :boolean
    column :any_time => :time
    column :birthday => :date
    column :created_at => :datetime
    column(:account) {|record| record.account.name}
    column(:updated_at) do |record|
      record.updated_at.strftime("%d/%m/%Y %H:%M:%S")
    end
  end

  # exporter :simple do
  #   column :nome
  #   column :email
  # end

end
```

### How to use

You can call `export_to` from **Array** or **ActiveRecord::Relation** objects: 
```erb
    records = MyModel.all
    records.export_to(:csv) # or MyModelExporter.export_to_csv(records)
    
    records = [MyModel.first, MyModel.last]
    records.export_to(:xml) # or MyModelExporter.export_to_xml(records)
```

### Avaliable Types

You can call `RailsExporter::Base.file_types` to list all supported file types:
```ruby
RailsExporter::Base.file_types.each do |type|
 puts type
end
```

### I18n Configuration

Modify you `config/locales/exporters.en.yml`

### Controller Example

```erb
class UsersController < ApplicationController
  def index
    @users = User.all
    respond_to do |format|
      format.html
      format.csv { send_data @users.export_to(:csv) }
      format.xml { send_data @users.export_to(:xml) }
      format.xls { send_data @users.export_to(:xls) }
      format.xlsx { send_data @users.export_to(:xlsx) }
    end
  end
end
```
### MimeTypes

Declare XLS as a new mimetype in `config/initializers/mime_types`:
```erb
    Mime::Type.register "application/vnd.ms-excel", :xls
    Mime::Type.register "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", :xlsx
```