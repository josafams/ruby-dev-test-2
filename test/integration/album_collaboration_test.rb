require 'test_helper'

class AlbumCollaborationTest < ActiveSupport::TestCase
  test "Madonna and Shakira can collaborate on an album" do
    madonna = Player.find_or_create_by(name: 'Madonna')
    shakira = Player.find_or_create_by(name: 'Shakira')
    
    collaboration_album = Album.new(name: 'Madonna & Shakira Collaboration')
    collaboration_album.players << madonna
    collaboration_album.players << shakira
    collaboration_album.save!
    
    assert_equal 2, collaboration_album.players.count
    assert_includes collaboration_album.players, madonna
    assert_includes collaboration_album.players, shakira
    
    assert_includes madonna.albums, collaboration_album
    assert_includes shakira.albums, collaboration_album
  end

  test "album can have multiple collaborations" do
    madonna = Player.find_or_create_by(name: 'Madonna')
    shakira = Player.find_or_create_by(name: 'Shakira')
    beyonce = Player.find_or_create_by(name: 'Beyonce')
    
    super_collaboration = Album.new(name: 'Super Collaboration Album')
    super_collaboration.players << [madonna, shakira, beyonce]
    super_collaboration.save!
    
    assert_equal 3, super_collaboration.players.count
    assert_includes super_collaboration.players, madonna
    assert_includes super_collaboration.players, shakira
    assert_includes super_collaboration.players, beyonce
  end

  test "cannot add same player twice to same album" do
    madonna = Player.find_or_create_by(name: 'Madonna')
    album = Album.new(name: 'Test Album')
    album.players << madonna
    album.save!
    
    assert_equal 1, album.players.count
    
    begin
      album.players << madonna
    rescue ActiveRecord::RecordInvalid
      # Esperado - validação de unicidade impede duplicação
    end
    
    album.reload
    assert_equal 1, album.players.count
  end

  test "removing player from album collaboration" do
    madonna = Player.find_or_create_by(name: 'Madonna')
    shakira = Player.find_or_create_by(name: 'Shakira')
    
    album = Album.new(name: 'Temporary Collaboration')
    album.players << [madonna, shakira]
    album.save!
    
    assert_equal 2, album.players.count
    
    album.players.delete(madonna)
    
    assert_equal 1, album.players.count
    assert_not_includes album.players, madonna
    assert_includes album.players, shakira
  end
end 