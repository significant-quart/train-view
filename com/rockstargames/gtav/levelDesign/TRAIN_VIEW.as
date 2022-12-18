class com.rockstargames.gtav.levelDesign.TRAIN_VIEW extends com.rockstargames.gtav.levelDesign.BaseScriptUI
{
	var _depth:Number = 1;

	var trainNodeHeights:Object = [];
	var trainNodeTypes:Object = [];
	var trainNodeLabels:Object = [];

	var nCarriages:Number;

	var width:Number;
	var padding:Number;
	var margin:Number;

	var engineCarriageColour:Number;
	var carriageColour:Number;
	var trackNodeColour:Number;
	var stationNodeColour:Number;
	var nodePosition:Number;
	var nNodes:Number;

	var backwards:Boolean = true;

	var maxHeight:Number = 0.0;
	var minHeight:Number = 99999.0;

	function INITIALISE(mc:MovieClip):Void
	{
		this.TIMELINE = mc;
		this.CONTENT = this.TIMELINE.attachMovie("CONTENT", "CONTENT", this.TIMELINE.getNextHighestDepth());

		this.engineCarriageColour = com.rockstargames.ui.utils.Colour.RGBToHex(255, 0, 0);
		this.carriageColour = com.rockstargames.ui.utils.Colour.RGBToHex(169, 169, 169);
		this.trackNodeColour = com.rockstargames.ui.utils.Colour.RGBToHex(211, 211, 211);
		this.stationNodeColour = com.rockstargames.ui.utils.Colour.RGBToHex(255, 0, 255);

		this.width = this.CONTENT.trainBg._width;
	}
	function getNextHighestDepth():Number
	{
		this._depth += 1;

		return this._depth;
	}
	function SET_TRAIN_VIEW_WIDTH(width:Number):Void
	{
		this.CONTENT.trainBg._width = width;
		this.width = width;
	}
	function SET_TRAIN_VIEW_PADDING(lr:Number, tb:Number):Void
	{
		this.margin = lr;

		this.CONTENT.trainBg._width = this.width + (lr * 2);

		this.padding = tb;
	}
	function SET_TRAIN_VIEW_XY(x:Number, y:Number):Void
	{
		this.CONTENT._x = x;
		this.CONTENT._y = y;
	}
	function SET_TRAIN_VIEW_VISIBLE_NODES(n:Number):Void
	{
		if (n <= 0)
		{
			return;
		}

		if ((n % 2) === 0)
		{
			n = n + 1;
		}

		if (this.nNodes != "undefined" && n > this.nNodes)
		{
			this.DELETE_NODE_OF_TYPE("node");
		}

		this.nNodes = n;
	}
	function SET_N_TRAIN_CARRIAGES(carriages:Number):Void
	{
		if (this.nCarriages != "undefined" && carriages > this.nCarriages)
		{
			this.DELETE_NODE_OF_TYPE("carriage");
		}
		for (var i:Number = 0; i < carriages; i++)
		{
			this.CONTENT.attachMovie("node",("carriage_" + i),getNextHighestDepth());
		}

		this.nCarriages = carriages;
	}
	function SET_TRAIN_VIEW_NODE_INDEX(nodePosition:Number):Void
	{
		this.nodePosition = nodePosition;

		this.drawNodes();
	}
	function getNodeIndex(jump:Number):Number
	{
		if (this.backwards === true)
		{
			jump = -jump;
		}

		if (jump > 0 && (this.nodePosition + jump) > (this.trainNodeHeights.length - 1))
		{
			return (this.nodePosition + jump) - (this.trainNodeHeights.length - 1);
		}
		else if ((this.nodePosition + jump) < 0)
		{
			return (this.trainNodeHeights.length - 1) - Math.abs(this.nodePosition + jump);
		}
		else
		{
			return this.nodePosition + jump;
		}
	}
	function calculateHeightDecimal(height:Number):Number
	{
		return (this.maxHeight - height) / (this.maxHeight - minHeight);
	}
	function drawNodes():Void
	{
		DELETE_NODE_OF_TYPE("station");
		var labelIndex = 0;

		var nodeLength:Number = (this.CONTENT.trainBg._width - (this.margin * 2)) / this.nNodes;
		var midPoint:Number = Math.ceil(this.nNodes / 2) - 1;

		var i:Number = (this.backwards == true ? (this.nNodes - 1) : 0);
		while ((this.backwards === true && i > -1) || (this.backwards === false && i < this.nNodes))
		{
			var relativeNodeJump:Number;
			if (i < midPoint)
			{
				relativeNodeJump = i - (midPoint);
			}
			else if (i > midPoint)
			{
				relativeNodeJump = i - (midPoint);
			}
			else
			{
				relativeNodeJump = 0;
			}
			var nodeIndex:Number = getNodeIndex(relativeNodeJump);

			var nodeX:Number = (i * nodeLength) + this.margin;
			var nodeY:Number = this.padding + (calculateHeightDecimal(this.trainNodeHeights[nodeIndex]) * (this.CONTENT.trainBg._height - this.padding * 2));

			var nodeMC:MovieClip;
			if (typeof this.CONTENT["node_" + i] == "undefined")
			{
				nodeMC = this.CONTENT.attachMovie("node", ("node_" + i), getNextHighestDepth(), {_visible:true, _x:nodeX, _y:nodeY, _width:nodeLength, _height:nodeLength});
			}
			else
			{
				nodeMC = this.CONTENT["node_" + i];
				nodeMC._width = nodeMC._height = nodeLength;
				nodeMC._x = nodeX;
				nodeMC._y = nodeY;
			}

			var nodeColourObject:Color = new Color(nodeMC);
			if (trainNodeTypes[nodeIndex] !== 0 && trainNodeTypes[getNodeIndex(relativeNodeJump + 1)] === 0)
			{
				nodeColourObject.setRGB(this.stationNodeColour);

				nodeMC._height *= 2;
				nodeMC._y = nodeY - nodeLength;
			}
			else
			{
				nodeColourObject.setRGB(this.trackNodeColour);
			}

			if (i <= midPoint && (midPoint - i) <= this.nCarriages)
			{
				var carriageMC:MovieClip = this.CONTENT["carriage_" + (midPoint - i)];
				var carriageColourObj:Color = new Color(carriageMC);
				carriageMC._width = carriageMC._height = nodeLength;
				carriageMC._x = nodeX;
				carriageMC._y = nodeY - nodeLength;

				if (i === midPoint)
				{
					carriageColourObj.setRGB(this.engineCarriageColour);
				}
				else
				{
					carriageColourObj.setRGB(this.carriageColour);
				}

				if (carriageMC.getDepth() < nodeMC.getDepth())
				{
					carriageMC.swapDepths(nodeMC);
				}
			}

			if (typeof this.trainNodeLabels[nodeIndex] != "undefined")
			{
				this.CONTENT.attachMovie("station_name",("station_" + labelIndex),getNextHighestDepth());
				var stationMC = this.CONTENT["station_" + labelIndex];
				stationMC.station.text = this.trainNodeLabels[nodeIndex];
				stationMC._x = nodeMC._x - (stationMC.station.textWidth / 2);
				stationMC._y = nodeMC._y - nodeMC._height - (stationMC.station.textHeight / 2);

				labelIndex += 1;
			}

			if (this.backwards === true)
			{
				i = i - 1;
			}
			else
			{
				i = i + 1;
			}
		}
	}
	function DELETE_NODE_OF_TYPE(type:String):Void
	{
		var i:Number = 0;
		while (typeof this.CONTENT[type + "_" + i] != "undefined")
		{
			this.CONTENT[type + "_" + i].removeMovieClip();
			i = i + 1;
		}
	}
	function ADD_NODE(z:Number, type:Number, label:String):Void
	{
		if (z > maxHeight)
		{
			maxHeight = z;
		}
		else if (z < minHeight)
		{
			minHeight = z;
		}

		this.trainNodeHeights.push(z);
		this.trainNodeTypes.push(type);

		if (typeof label != "undefined")
		{
			this.trainNodeLabels[this.trainNodeHeights.length - 1] = label;
		}

	}
}