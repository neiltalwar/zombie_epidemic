require_relative '../spec_helper'

describe ZombieEpidemic::State do
  let(:name)          { 'state' }
  let(:state)         { ZombieEpidemic::State.new('other') }
  let(:another_state) { ZombieEpidemic::State.new('yet another') }
  let(:transition)    { ->(_, _) { true } }
  subject             { ZombieEpidemic::State.new(name) }

  it 'has a name' do
    subject.name.must_equal name
  end

  it 'triggers a transition to another state when conditions met' do
    subject.add_transition(
      state,
      transition
    )

    subject.trigger_transition(Object.new).must_equal state
  end

  it 'decide the stay action for an agent by default' do
    subject.decide_action_for(Object.new).must_equal :stay
  end

  it 'trigers a transition with the highest priority to another state when conditions met' do
    subject.add_transition(
      state,
      transition
    )

    subject.add_transition(
      another_state,
      transition,
      10
    )
    
    subject.add_transition(
      state,
      transition
    )

    subject.trigger_transition(Object.new).must_equal another_state
  end
end