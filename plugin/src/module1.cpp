#include "plugin.hpp"

// Declare pluginInstance as an extern variable before using it
extern Plugin* pluginInstance;

struct Module1 : Module {
	enum ParamId {
		PARAM1_PARAM,
		PARAMS_LEN
	};
	enum InputId {
		INPUT1_INPUT,
		INPUTS_LEN
	};
	enum OutputId {
		OUTPUT1_OUTPUT,
		OUTPUTS_LEN
	};
	enum LightId {
		LIGHT1_LIGHT,
		LIGHTS_LEN
	};

	Module1() {
		config(PARAMS_LEN, INPUTS_LEN, OUTPUTS_LEN, LIGHTS_LEN);
		configParam(PARAM1_PARAM, 0.f, 1.f, 0.f, "");
		configInput(INPUT1_INPUT, "");
		configOutput(OUTPUT1_OUTPUT, "");
	}

	void process(const ProcessArgs& args) override {
	}
};


struct Module1Widget : ModuleWidget {
	Module1Widget(Module1* module) {
		setModule(module);
		setPanel(createPanel(asset::plugin(pluginInstance, "res/module1.svg")));

		addChild(createWidget<ScrewSilver>(Vec(RACK_GRID_WIDTH, 0)));
		addChild(createWidget<ScrewSilver>(Vec(box.size.x - 2 * RACK_GRID_WIDTH, 0)));
		addChild(createWidget<ScrewSilver>(Vec(RACK_GRID_WIDTH, RACK_GRID_HEIGHT - RACK_GRID_WIDTH)));
		addChild(createWidget<ScrewSilver>(Vec(box.size.x - 2 * RACK_GRID_WIDTH, RACK_GRID_HEIGHT - RACK_GRID_WIDTH)));

		addParam(createParamCentered<RoundBlackKnob>(mm2px(Vec(20.32, 8.202)), module, Module1::PARAM1_PARAM));

		addInput(createInputCentered<PJ301MPort>(mm2px(Vec(20.32, 35.917)), module, Module1::INPUT1_INPUT));

		addOutput(createOutputCentered<PJ301MPort>(mm2px(Vec(20.32, 63.632)), module, Module1::OUTPUT1_OUTPUT));

		addChild(createLightCentered<MediumLight<RedLight>>(mm2px(Vec(20.32, 91.347)), module, Module1::LIGHT1_LIGHT));

		addChild(createWidgetCentered<Widget>(mm2px(Vec(20.32, 119.063))));
	}
};


Model* modelModule1 = createModel<Module1, Module1Widget>("module1");