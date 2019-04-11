require "./spec_helper"

class String
  include SpintaxParser
end

Spec2.describe SpintaxParser do
  let(:plaintext) { "Hello world. Please do not spin this." }
  let(:spintext) { "Find this. {Hello|Hi} to the {{world|worlds} out there|planet}{!|.|?} Cool." }
  let(:spintax_pattern) { SpintaxParser::SPINTAX_PATTERN }

  describe "calling unspin" do
    context "on plaintext" do
      it "does not change the plaintext" do
        plaintext.unspin
        expect(plaintext).to eq("Hello world. Please do not spin this.")
      end

      let(:result) { plaintext.unspin }
      it "returns the same plaintext" do
        expect(result).to eq(plaintext)
      end
    end

    context "on spintext" do
      it "does not change the spintext" do
        spintext.unspin
        expect(spintext).to eq "Find this. {Hello|Hi} to the {{world|worlds} out there|planet}{!|.|?} Cool."
      end

      let(:result) { spintext.unspin }
      it "should be different" do
        expect(result).not_to eq spintext
      end
      it "should remove all fields" do
        expect(result).not_to match spintax_pattern
      end
    end

    context "with the same rng supplied" do
      it "produces the same unspun version each time" do
        seed = Random::PCG32.new.new_seed
        unspun1 = spintext.unspin Random.new(seed)
        unspun2 = spintext.unspin Random.new(seed)
        expect(unspun1).to eq unspun2
      end
    end
  end

  it "should count spun variations correctly" do
    expect("one {two|three} four".count_spintax_variations).to eq 2
    expect("{one|two {three|four}} five".count_spintax_variations).to eq 3
    expect("{one|two} three {four|five}".count_spintax_variations).to eq 4
    expect("one {{two|three} four|five {six|seven}} eight {nine|ten}".count_spintax_variations).to eq 8
    expect("{Hello|Hi} {{world|worlds}|planet}{!|.|?}".count_spintax_variations).to eq 18
    # expect("{one|two|}".count_spintax_variations).to eq 3
    expect("{Can't|count|this one".count_spintax_variations).to eq nil
  end
end
