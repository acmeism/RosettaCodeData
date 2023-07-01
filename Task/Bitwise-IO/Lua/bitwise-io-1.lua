local function BitWriter() return {
    accumulator = 0, -- For current byte.
    bitCount    = 0, -- Bits set in current byte.
    outChars    = {},

    -- writer:writeBit( bit )
    writeBit = function(writer, bit)
        writer.bitCount = writer.bitCount + 1
        if bit > 0 then
            writer.accumulator = writer.accumulator + 2^(8-writer.bitCount)
        end
        if writer.bitCount == 8 then
            writer:_flush()
        end
    end,

    -- writer:writeLsb( value, width )
    writeLsb = function(writer, value, width)
        for i = 1, width do
            writer:writeBit(value%2)
            value = math.floor(value/2)
        end
    end,

    -- dataString = writer:getOutput( )
    getOutput = function(writer)
        writer:_flush()
        return table.concat(writer.outChars)
    end,

    _flush = function(writer)
        if writer.bitCount == 0 then  return  end

        table.insert(writer.outChars, string.char(writer.accumulator))
        writer.accumulator = 0
        writer.bitCount    = 0
    end,
} end

local function BitReader(data) return {
    bitPosition = 0, -- Absolute position in 'data'.

    -- bit = reader:readBit( ) -- Returns nil at end-of-data.
    readBit = function(reader)
        reader.bitPosition = reader.bitPosition + 1
        local bytePosition = math.floor((reader.bitPosition-1)/8) + 1

        local byte = data:byte(bytePosition)
        if not byte then  return nil  end

        local bitIndex = ((reader.bitPosition-1)%8) + 1
        return math.floor(byte / 2^(8-bitIndex)) % 2
    end,

    -- value = reader:readLsb( width ) -- Returns nil at end-of-data.
    readLsb = function(reader, width)
        local accumulator = 0

        for i = 1, width do
            local bit = reader:readBit()
            if not bit then  return nil  end

            if bit > 0 then
                accumulator = accumulator + 2^(i-1)
            end
        end

        return accumulator
    end,
} end
