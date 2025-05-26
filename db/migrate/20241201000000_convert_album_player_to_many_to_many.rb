class ConvertAlbumPlayerToManyToMany < ActiveRecord::Migration[5.2]
  def up
    # Criar tabela de backup dos dados existentes
    # Isso poderia ser feito DE N formas desde um dump completo do db ou apenas das tabelas que terão
    # modificação.
    create_table :albums_backup do |t|
      t.string :name
      t.integer :player_id
      t.datetime :created_at
      t.datetime :updated_at
    end

    execute <<-SQL
      INSERT INTO albums_backup (name, player_id, created_at, updated_at)
      SELECT name, player_id, created_at, updated_at FROM albums;
    SQL

    # Criar tabela de junção para relacionamento N:N
    create_table :album_players do |t|
      t.references :album, null: false, foreign_key: true
      t.references :player, null: false, foreign_key: true
      t.timestamps
    end

    add_index :album_players, [:album_id, :player_id], unique: true
    
    # Isso poderia ser feito via LOTES pelo Active::Record ou bulk insert
    execute <<-SQL
      INSERT INTO album_players (album_id, player_id, created_at, updated_at)
      SELECT id, player_id, created_at, updated_at FROM albums
      WHERE player_id IS NOT NULL;
    SQL

    remove_foreign_key :albums, :players
    remove_index :albums, :player_id
    remove_column :albums, :player_id
  end

  def down
    add_reference :albums, :player, foreign_key: true

    # Restaurar dados do backup (pegar o primeiro player de cada album)
    execute <<-SQL
      UPDATE albums 
      SET player_id = (
        SELECT player_id 
        FROM album_players 
        WHERE album_players.album_id = albums.id 
        LIMIT 1
      );
    SQL

    drop_table :album_players
    drop_table :albums_backup
  end
end 