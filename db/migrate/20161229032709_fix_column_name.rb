class FixColumnName < ActiveRecord::Migration[5.0]
  
  def change
    change_table :profiles do |t|
      t.rename :job_tittle, :job_title
    end
  end
end
